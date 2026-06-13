import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'core/config/app_config.dart';
import 'core/config/firebase_bootstrap.dart';
import 'core/network/railway_api_client.dart';
import 'features/auth/data/firebase_auth_repository.dart';
import 'main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.initializeIfConfigured();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const SmClientApp());
}

class SmClientApp extends StatelessWidget {
  const SmClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmClient',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── Animated Splash Screen ──────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Master timeline (3.6 s total) ────────────────────────────────────────
  late final AnimationController _master;
  // ── Continuous loops ─────────────────────────────────────────────────────
  late final AnimationController _orbit;
  late final AnimationController _pulse;
  late final AnimationController _float;

  // ── Derived phases ────────────────────────────────────────────────────────
  late final Animation<double> _bgFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _ringGrow;
  late final Animation<double> _textSlide;
  late final Animation<double> _textFade;
  late final Animation<double> _tagFade;
  late final Animation<double> _pill1;
  late final Animation<double> _pill2;
  late final Animation<double> _pill3;
  late final Animation<double> _loaderFill;
  late final Animation<double> _exitFade;

  Animation<double> _iv(double b, double e, {Curve curve = Curves.easeOut}) =>
      CurvedAnimation(parent: _master, curve: Interval(b, e, curve: curve));

  @override
  void initState() {
    super.initState();

    _master = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3600))
      ..forward();
    _orbit =
        AnimationController(vsync: this, duration: const Duration(seconds: 7))
          ..repeat();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _float = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat(reverse: true);

    // Phase timings (normalised 0–1 of 3600 ms)
    _bgFade = _iv(0.00, 0.14);
    _logoFade = _iv(0.08, 0.28);
    _logoScale = CurvedAnimation(
        parent: _master,
        curve: const Interval(0.08, 0.30, curve: Curves.elasticOut));
    _ringGrow = _iv(0.20, 0.40);
    _textFade = _iv(0.34, 0.54);
    _textSlide = _iv(0.34, 0.52, curve: Curves.easeOutCubic);
    _tagFade = _iv(0.48, 0.64);
    _pill1 = _iv(0.56, 0.70);
    _pill2 = _iv(0.62, 0.74);
    _pill3 = _iv(0.68, 0.80);
    _loaderFill = _iv(0.60, 0.96, curve: Curves.easeInOut);
    _exitFade = CurvedAnimation(
        parent: _master,
        curve: const Interval(0.93, 1.0, curve: Curves.easeIn));

    _master.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(
          _FadeRoute(page: const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _master.dispose();
    _orbit.dispose();
    _pulse.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF07090F),
      body: AnimatedBuilder(
        animation: Listenable.merge([_master, _orbit, _pulse, _float]),
        builder: (_, __) {
          return Stack(alignment: Alignment.center, children: [
            // ── Deep bg gradient ──────────────────────────────────────────
            Opacity(
              opacity: _bgFade.value,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.3),
                    radius: 1.4,
                    colors: [
                      Color(0xFF171130),
                      Color(0xFF0C0A1A),
                      Color(0xFF07090F),
                    ],
                  ),
                ),
              ),
            ),

            // ── Glow orbs ────────────────────────────────────────────────
            Positioned(
              top: size.height * 0.05,
              left: -60,
              child: Opacity(
                opacity: _bgFade.value * 0.7,
                child: _SplashOrb(
                  color: const Color(0xFF6366F1),
                  size: size.width * 0.7,
                  sigma: 70,
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.55,
              right: -80,
              child: Opacity(
                opacity: _bgFade.value * 0.5,
                child: _SplashOrb(
                  color: const Color(0xFF7C3AED),
                  size: size.width * 0.6,
                  sigma: 80,
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.1,
              left: size.width * 0.2,
              child: Opacity(
                opacity: _bgFade.value * 0.4,
                child: _SplashOrb(
                  color: const Color(0xFF06B6D4),
                  size: size.width * 0.5,
                  sigma: 90,
                ),
              ),
            ),

            // ── Background chat bubbles (floating) ────────────────────────
            Positioned(
              top: size.height * 0.14 + _float.value * 8,
              left: 28,
              child: Opacity(
                opacity: _tagFade.value * 0.22,
                child: const _FloatingBubble(
                    text: 'How can I help?', fromBot: true),
              ),
            ),
            Positioned(
              top: size.height * 0.22 - _float.value * 6,
              right: 24,
              child: Opacity(
                opacity: _tagFade.value * 0.18,
                child: const _FloatingBubble(
                    text: 'Book a session 📅', fromBot: false),
              ),
            ),
            Positioned(
              bottom: size.height * 0.24 + _float.value * 7,
              left: 20,
              child: Opacity(
                opacity: _pill3.value * 0.20,
                child: const _FloatingBubble(
                    text: 'Your order is ready ✅', fromBot: true),
              ),
            ),

            // ── Orbit ring ───────────────────────────────────────────────
            Opacity(
              opacity: _ringGrow.value,
              child: Transform.scale(
                scale: 0.4 + _ringGrow.value * 0.6,
                child: CustomPaint(
                  size: const Size(230, 230),
                  painter: _NodeOrbitPainter(
                    progress: _orbit.value,
                    ringOpacity: _ringGrow.value * 0.35,
                  ),
                ),
              ),
            ),

            // ── Inner glow ring (pulsing) ─────────────────────────────────
            Opacity(
              opacity: _ringGrow.value * (0.6 + _pulse.value * 0.4),
              child: Container(
                width: 118 + _pulse.value * 4,
                height: 118 + _pulse.value * 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6366F1).withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            // ── Central bot logo ─────────────────────────────────────────
            Opacity(
              opacity: _logoFade.value,
              child: Transform.scale(
                scale: 0.4 + _logoScale.value * 0.6,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF818CF8),
                        Color(0xFF6366F1),
                        Color(0xFF4F46E5)
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1)
                            .withOpacity(0.45 + _pulse.value * 0.25),
                        blurRadius: 42 + _pulse.value * 18,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(alignment: Alignment.center, children: [
                    // Subtle inner shine
                    Positioned(
                      top: 6,
                      left: 10,
                      child: Container(
                        width: 36,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.22),
                              Colors.transparent
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Bot icon
                    const Icon(Icons.smart_toy_rounded,
                        size: 44, color: Colors.white),
                  ]),
                ),
              ),
            ),

            // ── Text + pills column ───────────────────────────────────────
            Positioned(
              bottom: size.height * 0.18,
              left: 0,
              right: 0,
              child: Column(children: [
                // Brand
                Opacity(
                  opacity: _textFade.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _textSlide.value)),
                    child: ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [
                          Color(0xFFE0E7FF),
                          Color(0xFFC7D2FE),
                          Color(0xFF818CF8)
                        ],
                      ).createShader(b),
                      child: const Text(
                        'SmClient',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1.2,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                Opacity(
                  opacity: _tagFade.value,
                  child: Text(
                    'your smart client platform',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.38),
                      letterSpacing: 2.2,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Feature pills row
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _SplashPill(
                      label: 'AI Bots',
                      icon: Icons.smart_toy_rounded,
                      opacity: _pill1.value),
                  const SizedBox(width: 8),
                  _SplashPill(
                      label: 'Analytics',
                      icon: Icons.bar_chart_rounded,
                      opacity: _pill2.value),
                  const SizedBox(width: 8),
                  _SplashPill(
                      label: 'Bookings',
                      icon: Icons.calendar_month_rounded,
                      opacity: _pill3.value),
                ]),
              ]),
            ),

            // ── Progress loader bar ───────────────────────────────────────
            Positioned(
              bottom: size.height * 0.09,
              left: 48,
              right: 48,
              child: Opacity(
                opacity: _loaderFill.value,
                child: Column(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 2.5,
                      color: Colors.white.withOpacity(0.08),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _loaderFill.value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withOpacity(0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'v1.0.0 · SmClient',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.2),
                      letterSpacing: 2,
                    ),
                  ),
                ]),
              ),
            ),

            // ── Exit fade overlay ─────────────────────────────────────────
            IgnorePointer(
              child: Container(
                color: const Color(0xFF07090F).withOpacity(_exitFade.value),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

// ── Splash orb helper ─────────────────────────────────────────────────────────
class _SplashOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double sigma;
  const _SplashOrb(
      {required this.color, required this.size, required this.sigma});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: color.withOpacity(0.55)),
      ),
    );
  }
}

// ── Feature pill ──────────────────────────────────────────────────────────────
class _SplashPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final double opacity;
  const _SplashPill(
      {required this.label, required this.icon, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, 12 * (1 - opacity.clamp(0.0, 1.0))),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 11, color: const Color(0xFF818CF8)),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE0E7FF),
                letterSpacing: 0.3,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ── Floating chat bubble ──────────────────────────────────────────────────────
class _FloatingBubble extends StatelessWidget {
  final String text;
  final bool fromBot;
  const _FloatingBubble({required this.text, required this.fromBot});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: fromBot
            ? const Color(0xFF6366F1).withOpacity(0.25)
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(14),
          topRight: const Radius.circular(14),
          bottomLeft: fromBot ? Radius.zero : const Radius.circular(14),
          bottomRight: fromBot ? const Radius.circular(14) : Radius.zero,
        ),
        border: Border.all(
          color: fromBot
              ? const Color(0xFF6366F1).withOpacity(0.30)
              : Colors.white.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE0E7FF),
        ),
      ),
    );
  }
}

// ── Orbit node painter ────────────────────────────────────────────────────────
class _NodeOrbitPainter extends CustomPainter {
  final double progress;
  final double ringOpacity;
  const _NodeOrbitPainter({required this.progress, required this.ringOpacity});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Dashed orbit ring
    final ringPaint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(ringOpacity)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dash = 6.0, gap = 5.0;
    final circum = 2 * math.pi * r;
    var drawn = 0.0;
    var dashOn = true;
    double angle = 0;
    while (drawn < circum) {
      final seg = dashOn ? dash : gap;
      final sweep = seg / r;
      if (dashOn) {
        canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
            angle, sweep, false, ringPaint);
      }
      angle += sweep;
      drawn += seg;
      dashOn = !dashOn;
    }

    // Orbiting nodes (4 dots, equally spaced, rotating)
    const nodeCount = 4;
    const sizes = [5.0, 4.0, 3.5, 4.5];
    const opacities = [1.0, 0.65, 0.45, 0.80];
    for (int i = 0; i < nodeCount; i++) {
      final theta = (progress * 2 * math.pi) + (i * 2 * math.pi / nodeCount);
      final nx = cx + r * math.cos(theta);
      final ny = cy + r * math.sin(theta);
      canvas.drawCircle(
        Offset(nx, ny),
        sizes[i],
        Paint()..color = const Color(0xFF818CF8).withOpacity(opacities[i]),
      );
      // Trailing glow
      canvas.drawCircle(
        Offset(nx, ny),
        sizes[i] * 2.2,
        Paint()
          ..color = const Color(0xFF6366F1).withOpacity(0.18 * opacities[i])
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  @override
  bool shouldRepaint(_NodeOrbitPainter old) =>
      old.progress != progress || old.ringOpacity != ringOpacity;
}

class _FadeRoute extends PageRouteBuilder {
  final Widget page;
  _FadeRoute({required this.page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        );
}

class _SlideUpRoute extends PageRouteBuilder {
  final Widget page;
  _SlideUpRoute({required this.page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 420),
        );
}

String _authErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return error.message ?? 'Authentication failed.';
    }
  }

  final message = error.toString();
  if (message.contains('sign_in_canceled') ||
      message.contains('popup-closed-by-user')) {
    return 'Sign-in was cancelled.';
  }
  if (message.contains('firebase-not-configured')) {
    return 'Firebase is not configured correctly for this app build.';
  }
  if (message.contains('ApiException: 10') ||
      message.contains('DEVELOPER_ERROR') ||
      message.contains('12500')) {
    return 'Google Sign-In configuration error. Re-check SHA-1/SHA-256 in Firebase and redownload google-services.json.';
  }

  return 'Authentication failed. Please try again.';
}

String _backendSyncErrorMessage(Object error) {
  final message = error.toString();

  if (message.contains('RAILWAY_API_BASE_URL is not configured')) {
    return 'Backend URL is missing. Start app with --dart-define=RAILWAY_API_BASE_URL=...';
  }
  if (message.contains('Connection refused') ||
      message.contains('Failed host lookup') ||
      message.contains('SocketException') ||
      message.contains('Request failed')) {
    return 'Could not reach backend. Ensure local backend is running on port 8080.';
  }

  return 'Signed in to Firebase, but failed to sync backend user.';
}

Future<void> _syncBackendUserOrThrow() async {
  if (!AppConfig.hasRailwayApiBaseUrl) return;

  final firebaseAuth = FirebaseAuth.instance;
  var user = firebaseAuth.currentUser;
  if (user == null) {
    user = await firebaseAuth.authStateChanges().firstWhere((u) => u != null);
  }

  if (user == null) {
    throw StateError('No authenticated user available to sync.');
  }

  final client = RailwayApiClient(firebaseAuth: firebaseAuth);
  await client.post(
    '/users/me/sync',
    body: {
      if ((user.displayName ?? '').trim().isNotEmpty)
        'displayName': user.displayName,
      if ((user.photoURL ?? '').trim().isNotEmpty) 'photoUrl': user.photoURL,
    },
  );
}

void _showAuthSnackBar(
  BuildContext context,
  String message, {
  bool isError = true,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor:
          isError ? const Color(0xFFB91C1C) : const Color(0xFF047857),
    ),
  );
}

// ─── Login Screen ─────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _authRepository = FirebaseAuthRepository();

  // Demo credentials – pre-filled for quick access
  final _emailCtrl = TextEditingController(text: 'demo@smclient.com');
  final _passCtrl = TextEditingController(text: 'demo1234');

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isAuthBusy = false;
  late final AnimationController _entryController;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _entryFade = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = _authRepository.currentUser;
      if (mounted && currentUser != null) {
        Navigator.of(context)
            .pushReplacement(_FadeRoute(page: const MainShell()));
      }
    });
  }

  String? _validateLoginInput() {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      return 'Please enter both email and password.';
    }

    if (!email.contains('@')) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  Future<void> _signIn() async {
    if (_isAuthBusy) return;

    final validationError = _validateLoginInput();
    if (validationError != null) {
      _showAuthSnackBar(context, validationError);
      return;
    }

    setState(() => _isAuthBusy = true);
    try {
      try {
        await _authRepository.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );
      } catch (error) {
        if (!mounted) return;
        _showAuthSnackBar(context, _authErrorMessage(error));
        return;
      }

      try {
        await _syncBackendUserOrThrow();
      } catch (error) {
        if (!mounted) return;
        _showAuthSnackBar(context, _backendSyncErrorMessage(error));
        await _authRepository.signOut();
        return;
      }

      if (!mounted) return;
      Navigator.of(context)
          .pushReplacement(_FadeRoute(page: const MainShell()));
    } finally {
      if (mounted) setState(() => _isAuthBusy = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isAuthBusy) return;

    setState(() => _isAuthBusy = true);
    try {
      try {
        await _authRepository.signInWithGoogle();
      } catch (error) {
        if (!mounted) return;
        _showAuthSnackBar(context, _authErrorMessage(error));
        return;
      }

      try {
        await _syncBackendUserOrThrow();
      } catch (error) {
        if (!mounted) return;
        _showAuthSnackBar(context, _backendSyncErrorMessage(error));
        await _authRepository.signOut();
        return;
      }

      if (!mounted) return;
      Navigator.of(context)
          .pushReplacement(_FadeRoute(page: const MainShell()));
    } finally {
      if (mounted) setState(() => _isAuthBusy = false);
    }
  }

  Future<void> _signInWithApple() async {
    if (_isAuthBusy) return;

    setState(() => _isAuthBusy = true);
    try {
      try {
        await _authRepository.signInWithApple();
      } catch (error) {
        if (!mounted) return;
        _showAuthSnackBar(context, _authErrorMessage(error));
        return;
      }

      try {
        await _syncBackendUserOrThrow();
      } catch (error) {
        if (!mounted) return;
        _showAuthSnackBar(context, _backendSyncErrorMessage(error));
        await _authRepository.signOut();
        return;
      }

      if (!mounted) return;
      Navigator.of(context)
          .pushReplacement(_FadeRoute(page: const MainShell()));
    } finally {
      if (mounted) setState(() => _isAuthBusy = false);
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    if (_isAuthBusy) return;

    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showAuthSnackBar(context, 'Enter a valid email to reset password.');
      return;
    }

    setState(() => _isAuthBusy = true);
    try {
      await _authRepository.sendPasswordResetEmail(email);

      if (!mounted) return;
      _showAuthSnackBar(
        context,
        'Password reset email sent to $email.',
        isError: false,
      );
    } catch (error) {
      if (!mounted) return;
      _showAuthSnackBar(context, _authErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isAuthBusy = false);
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF1F8),
      body: Stack(
        children: [
          // ── Mesh Background Orbs (Bottom Area) ───────────────────────────
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                  width: 350,
                  height: 350,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(99, 102, 241, 0.20))),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            right: -150,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(
                  width: 450,
                  height: 450,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(16, 185, 129, 0.16))),
            ),
          ),
          Positioned(
            bottom: -50,
            left: MediaQuery.of(context).size.width * 0.1,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(
                  width: 400,
                  height: 400,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(99, 102, 241, 0.18))),
            ),
          ),

          // ── Mesh gradient header ──────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF4F46E5),
                    Color(0xFFEEF2FF),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _entryFade,
              child: SlideTransition(
                position: _entrySlide,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 40),

                    // Brand icon
                    Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: Color(0xFF6366F1),
                          size: 30,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Glass card ────────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.88),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withOpacity(0.10),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          const Center(
                            child: Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Center(
                            child: Text(
                              'SIGN IN TO CONTINUE TO SMCLIENT',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF94A3B8),
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Email field
                          _FieldLabel(label: 'Email Address'),
                          const SizedBox(height: 6),
                          _PremiumTextField(
                            hintText: 'name@company.com',
                            prefixIcon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailCtrl,
                          ),

                          const SizedBox(height: 16),

                          // Password field
                          _FieldLabel(label: 'Password'),
                          const SizedBox(height: 6),
                          _PremiumTextField(
                            hintText: '••••••••',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            controller: _passCtrl,
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 17,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Remember me + Forgot
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _rememberMe = !_rememberMe),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        onChanged: (v) => setState(
                                            () => _rememberMe = v ?? false),
                                        activeColor: const Color(0xFF6366F1),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        side: const BorderSide(
                                            color: Color(0xFFCBD5E1)),
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    const Text(
                                      'Remember me',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: _isAuthBusy
                                    ? null
                                    : _sendPasswordResetEmail,
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Sign In button
                          _PrimaryButton(
                            label: _isAuthBusy ? 'Please wait...' : 'Sign In',
                            onTap: _signIn,
                          ),

                          // Divider
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                const Expanded(
                                    child: Divider(color: Color(0xFFE2E8F0))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    'SOCIAL LOGIN',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                    child: Divider(color: Color(0xFFE2E8F0))),
                              ],
                            ),
                          ),

                          // Social buttons
                          Row(
                            children: [
                              Expanded(
                                child: _SocialButton(
                                  label: 'Google',
                                  icon: Icons.g_mobiledata_rounded,
                                  onTap:
                                      _isAuthBusy ? () {} : _signInWithGoogle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _SocialButton(
                                  label: 'Apple',
                                  icon: Icons.apple_rounded,
                                  onTap: _isAuthBusy ? () {} : _signInWithApple,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Sign up link
                          GestureDetector(
                            onTap: _isAuthBusy
                                ? null
                                : () => Navigator.of(context).push(
                                      _SlideUpRoute(
                                          page: const RegisterScreen()),
                                    ),
                            child: Center(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  children: [
                                    TextSpan(text: "Don't have an account? "),
                                    TextSpan(
                                      text: 'Sign up free',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF6366F1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Footer
                    const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shield_outlined,
                              size: 11, color: Color(0xFF94A3B8)),
                          SizedBox(width: 4),
                          Text(
                            'Secure Encryption Enabled',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Register Screen ─────────────────────────────────────────────────────────

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _authRepository = FirebaseAuthRepository();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;
  bool _isAuthBusy = false;
  late final AnimationController _entryController;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _entryFade = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));
  }

  String? _validateRegisterInput() {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    final confirm = _confirmCtrl.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      return 'Please fill all fields.';
    }

    if (!email.contains('@')) {
      return 'Please enter a valid email address.';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    if (password != confirm) {
      return 'Password and confirm password do not match.';
    }

    if (!_agreeTerms) {
      return 'Please accept terms and policies to continue.';
    }

    return null;
  }

  Future<void> _createAccount() async {
    if (_isAuthBusy) return;

    final validationError = _validateRegisterInput();
    if (validationError != null) {
      _showAuthSnackBar(context, validationError);
      return;
    }

    setState(() => _isAuthBusy = true);
    try {
      try {
        await _authRepository.createUserWithEmailAndPassword(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );
      } catch (error) {
        if (!mounted) return;
        _showAuthSnackBar(context, _authErrorMessage(error));
        return;
      }

      try {
        await _syncBackendUserOrThrow();
      } catch (error) {
        if (!mounted) return;
        _showAuthSnackBar(context, _backendSyncErrorMessage(error));
        await _authRepository.signOut();
        return;
      }

      if (!mounted) return;
      _showAuthSnackBar(
        context,
        'Account created successfully.',
        isError: false,
      );
      Navigator.of(context).pushAndRemoveUntil(
        _FadeRoute(page: const MainShell()),
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _isAuthBusy = false);
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF1F8),
      body: Stack(
        children: [
          // ── Mesh Background Orbs (Bottom Area) ───────────────────────────
          Positioned(
            top: MediaQuery.of(context).size.height * 0.40,
            left: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                  width: 350,
                  height: 350,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(99, 102, 241, 0.20))),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            right: -150,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(
                  width: 450,
                  height: 450,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(16, 185, 129, 0.16))),
            ),
          ),
          Positioned(
            bottom: -50,
            left: MediaQuery.of(context).size.width * 0.1,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(
                  width: 400,
                  height: 400,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(99, 102, 241, 0.18))),
            ),
          ),

          // ── Mesh gradient header ────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF4F46E5),
                    Color(0xFFEEF2FF),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          // ── Content ─────────────────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _entryFade,
              child: SlideTransition(
                position: _entrySlide,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 48),

                    // Brand icon
                    Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: Color(0xFF6366F1),
                          size: 30,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Glass card ──────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.88),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withOpacity(0.10),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          const Center(
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Center(
                            child: Text(
                              'CREATE YOUR SMCLIENT ACCOUNT',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF94A3B8),
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          // Full Name
                          _FieldLabel(label: 'Full Name'),
                          const SizedBox(height: 6),
                          _PremiumTextField(
                            hintText: 'John Doe',
                            prefixIcon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.name,
                            controller: _nameCtrl,
                          ),

                          const SizedBox(height: 14),

                          // Email
                          _FieldLabel(label: 'Email Address'),
                          const SizedBox(height: 6),
                          _PremiumTextField(
                            hintText: 'name@company.com',
                            prefixIcon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailCtrl,
                          ),

                          const SizedBox(height: 14),

                          // Password
                          _FieldLabel(label: 'Password'),
                          const SizedBox(height: 6),
                          _PremiumTextField(
                            hintText: '••••••••',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            controller: _passCtrl,
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 17,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Confirm Password
                          _FieldLabel(label: 'Confirm Password'),
                          const SizedBox(height: 6),
                          _PremiumTextField(
                            hintText: '••••••••',
                            prefixIcon: Icons.shield_outlined,
                            obscureText: _obscureConfirm,
                            controller: _confirmCtrl,
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                              child: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 17,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Terms & Conditions
                          GestureDetector(
                            onTap: () =>
                                setState(() => _agreeTerms = !_agreeTerms),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Checkbox(
                                    value: _agreeTerms,
                                    onChanged: (v) => setState(
                                        () => _agreeTerms = v ?? false),
                                    activeColor: const Color(0xFF6366F1),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(
                                        color: Color(0xFFCBD5E1)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                      height: 1.4,
                                    ),
                                    children: [
                                      TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF6366F1),
                                        ),
                                      ),
                                      TextSpan(text: ' & '),
                                      TextSpan(
                                        text: 'Policies',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF6366F1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Create Account button
                          _PrimaryButton(
                            label: _isAuthBusy
                                ? 'Please wait...'
                                : 'Create Account',
                            onTap: _createAccount,
                          ),

                          const SizedBox(height: 20),

                          // Sign in link
                          GestureDetector(
                            onTap: _isAuthBusy
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: Center(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  children: [
                                    TextSpan(text: 'Already have an account? '),
                                    TextSpan(
                                      text: 'Sign in',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF6366F1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Footer
                    const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shield_outlined,
                              size: 11, color: Color(0xFF94A3B8)),
                          SizedBox(width: 4),
                          Text(
                            'Secure Encryption Enabled',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w800,
        color: Color(0xFF0F172A),
        letterSpacing: 1.5,
      ),
    );
  }
}

class _PremiumTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const _PremiumTextField({
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: Icon(prefixIcon, size: 15, color: const Color(0xFF94A3B8)),
          ),
          prefixIconConstraints: const BoxConstraints(),
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: suffixIcon,
                )
              : null,
          suffixIconConstraints: const BoxConstraints(),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        onTap: () {},
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _SocialButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF0F172A)),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotsLoader extends StatefulWidget {
  const _DotsLoader();

  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = ((_ctrl.value - delay) % 1.0 + 1.0) % 1.0;
            final scale = 0.6 + 0.8 * math.sin(t * math.pi).clamp(0.0, 1.0);
            final opacity = 0.3 + 0.7 * math.sin(t * math.pi).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6366F1).withOpacity(opacity),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
