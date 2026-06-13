import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dashboard_screen.dart';
import 'analytics_screen.dart';
import 'ai_screen.dart';
import 'bookings_screen.dart';

const _ki  = Color(0xFF6366F1);
const _kid = Color(0xFF4F46E5);
const _kr  = Color(0xFFF43F5E);
const _kDk = Color(0xFF0F172A);
const _kMu = Color(0xFF94A3B8);
const _kSb = Color(0xFF64748B);

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  MAIN SHELL â€“ Bottom nav + page switching
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const <Widget>[
    DashboardScreen(),
    AnalyticsScreen(),
    AiScreen(),
    BookingsScreen(),
    _ProfilePage(),
  ];

  void _onTap(int i) {
    if (i == 2) return; // center tab handled separately
    setState(() => _index = i);
  }

  void _onCenterTap() {
    setState(() => _index = 2);
  }

  static MainShellState? instance;

  @override
  void initState() {
    super.initState();
    instance = this;
  }

  @override
  void dispose() {
    instance = null;
    super.dispose();
  }

  static void navigateToProfile() {
    instance?.setState(() {
      instance?._index = 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFEDF1F8),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: _PremiumNavBar(
        index: _index,
        onTap: _onTap,
        onCenterTap: _onCenterTap,
      ),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  PREMIUM BOTTOM NAV BAR
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

class _PremiumNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;

  const _PremiumNavBar({
    required this.index,
    required this.onTap,
    required this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Drop shadow & Glass Background
            Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: _kDk.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFEEF2FF).withOpacity(0.90),
                          const Color(0xFFC7D2FE).withOpacity(0.40),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.6),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Icons Layer
            SizedBox(
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavBarItem(icon: Icons.home_rounded, label: 'Home', active: index == 0, onTap: () => onTap(0)),
                  _NavBarItem(icon: Icons.bar_chart_rounded, label: 'Analytics', active: index == 1, onTap: () => onTap(1)),
                  _CenterTab(active: index == 2, onTap: onCenterTap),
                  _NavBarItem(icon: Icons.calendar_month_rounded, label: 'Bookings', active: index == 3, onTap: () => onTap(3)),
                  _NavBarItem(icon: Icons.more_horiz_rounded, label: 'More', active: index == 4, onTap: () => onTap(4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€ Regular nav item â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: active ? _ki.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: active ? _ki : _kMu,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active ? _ki : _kMu,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€ Center elevated AI tab â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _CenterTab extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _CenterTab({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(0, -14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: active
                      ? const [_kid, _ki]
                      : const [_ki, _kid],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: _ki.withOpacity(active ? 0.5 : 0.35),
                    blurRadius: active ? 22 : 16,
                    offset: const Offset(0, 6),
                    spreadRadius: active ? 1 : 0,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Subtle ring
                  if (active)
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1.5,
                        ),
                      ),
                    ),
                  // Icon
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Color(0xFFE0E7FF)],
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'AI',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: active ? _ki : _kMu,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _BookingsPage extends StatelessWidget {
  const _BookingsPage();

  @override
  Widget build(BuildContext context) {
    return _PlaceholderPage(
      icon: Icons.calendar_month_rounded,
      label: 'Bookings',
      sub: 'Manage appointments',
    );
  }
}

class _ProfilePage extends StatefulWidget {
  const _ProfilePage();

  @override
  State<_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfilePage> {
  String _displayName = 'Eleanor Pena';
  String _initials = 'EP';
  String _businessName = 'Luxe Boutique Inc.';
  String _planName = 'Premium Plan';
  String _avatarUrl =
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80';

  String _businessEmail = 'hello@luxeboutique.com';
  String _businessPhone = '+1 212 555 0139';
  String _businessAddress = 'Chelsea, New York, USA';

  String _billingName = 'Luxe Boutique Inc.';
  String _billingMethod = 'Visa •••• 4592';
  String _billingCycle = 'Monthly';

  int _teamSize = 12;
  String _inviteEmail = '';

  bool _notifPush = true;
  bool _notifEmail = true;
  bool _notifSms = false;

  bool _twoFactorEnabled = true;
  bool _biometricEnabled = false;
  String _sessionTimeout = '30 min';

  void _openSheet(Widget sheet) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => sheet,
    );
  }

  void _openAvatarModal() {
    _openSheet(
      _AvatarEditSheet(
        avatarUrl: _avatarUrl,
        initials: _initials,
        onSave: (url, initials) {
          setState(() {
            _avatarUrl = url.trim();
            _initials = initials.trim().isEmpty ? _initials : initials.trim();
          });
        },
      ),
    );
  }

  void _openProfileDetailsModal() {
    _openSheet(
      _ProfileDetailsSheet(
        name: _displayName,
        businessName: _businessName,
        planName: _planName,
        onSave: (name, business, plan) {
          setState(() {
            _displayName = name.trim().isEmpty ? _displayName : name.trim();
            _businessName =
                business.trim().isEmpty ? _businessName : business.trim();
            _planName = plan.trim().isEmpty ? _planName : plan.trim();
            final parts = _displayName.trim().split(' ');
            if (parts.isNotEmpty) {
              final first = parts.first.isNotEmpty ? parts.first[0] : '';
              final last = parts.length > 1 && parts.last.isNotEmpty
                  ? parts.last[0]
                  : '';
              final computed = '$first$last'.toUpperCase();
              if (computed.trim().isNotEmpty) _initials = computed;
            }
          });
        },
      ),
    );
  }

  void _openBusinessDetailsModal() {
    _openSheet(
      _BusinessDetailsSheet(
        email: _businessEmail,
        phone: _businessPhone,
        address: _businessAddress,
        onSave: (email, phone, address) {
          setState(() {
            _businessEmail = email;
            _businessPhone = phone;
            _businessAddress = address;
          });
        },
      ),
    );
  }

  void _openBillingModal() {
    _openSheet(
      _BillingPaymentsSheet(
        accountName: _billingName,
        paymentMethod: _billingMethod,
        billingCycle: _billingCycle,
        onSave: (name, method, cycle) {
          setState(() {
            _billingName = name;
            _billingMethod = method;
            _billingCycle = cycle;
          });
        },
      ),
    );
  }

  void _openTeamMembersModal() {
    _openSheet(
      _TeamMembersSheet(
        teamSize: _teamSize,
        inviteEmail: _inviteEmail,
        onSave: (size, inviteEmail) {
          setState(() {
            _teamSize = size;
            _inviteEmail = inviteEmail;
          });
        },
      ),
    );
  }

  void _openNotificationsModal() {
    _openSheet(
      _NotificationsSheet(
        pushEnabled: _notifPush,
        emailEnabled: _notifEmail,
        smsEnabled: _notifSms,
        onSave: (push, email, sms) {
          setState(() {
            _notifPush = push;
            _notifEmail = email;
            _notifSms = sms;
          });
        },
      ),
    );
  }

  void _openSecurityModal() {
    _openSheet(
      _SecurityPrivacySheet(
        twoFactorEnabled: _twoFactorEnabled,
        biometricEnabled: _biometricEnabled,
        sessionTimeout: _sessionTimeout,
        onSave: (twoFactor, biometric, timeout) {
          setState(() {
            _twoFactorEnabled = twoFactor;
            _biometricEnabled = biometric;
            _sessionTimeout = timeout;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFFEDF1F8),
        body: Stack(children: [
          // ── Mesh Orbs ──────────────────────────────────────────────────────
          Positioned(
            top: -100,
            left: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 350,
                height: 350,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(99, 102, 241, 0.20),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            right: -150,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(
                width: 450,
                height: 450,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(16, 185, 129, 0.16),
                ),
              ),
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
                  color: Color.fromRGBO(99, 102, 241, 0.18),
                ),
              ),
            ),
          ),

          // ── Main layout ────────────────────────────────────────────────────
          Column(children: [
            // ── Header ───────────────────────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_ki, _kid],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  GestureDetector(
                    onTap: _openAvatarModal,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          _avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.white24,
                            child: Center(
                              child: Text(
                                _initials,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                        height: 1,
                      ),
                    ),
                    Text(
                      _displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ]),
                ]),
                Stack(children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _kr,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ]),
              ]),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero Section
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _ki.withOpacity(0.12),
                                    _kid.withOpacity(0.08),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(24)),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 10,
                            right: 10,
                            child: Row(
                              children: [
                                _HeaderIcon(
                                  icon: Icons.edit,
                                  tint: _ki,
                                  onTap: _openProfileDetailsModal,
                                ),
                                const SizedBox(width: 8),
                                _HeaderIcon(
                                  icon: Icons.share,
                                  tint: _ki,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Share profile link coming soon.'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 84,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: _openAvatarModal,
                                        child: Container(
                                          width: 84,
                                          height: 84,
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.08),
                                                blurRadius: 8,
                                              ),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child: Image.network(
                                              _avatarUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                color: Colors.grey.shade200,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  _initials,
                                                  style: const TextStyle(
                                                    color: _kDk,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        top: 10,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF25D366),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 6,
                                        bottom: 6,
                                        child: GestureDetector(
                                          onTap: _openAvatarModal,
                                          child: Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(
                                              color: _ki,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white, width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: _ki.withOpacity(0.2),
                                                  blurRadius: 6,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _displayName,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: _kDk,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: const Icon(
                                        Icons.check_circle,
                                        color: Colors.blue,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _businessName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: _openProfileDetailsModal,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient:
                                          const LinearGradient(colors: [_ki, _kid]),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      _planName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(
                                        width: 85,
                                        child: _StatItem(
                                            label: 'Revenue', value: '\$12,500')),
                                    SizedBox(
                                        width: 85,
                                        child: _StatItem(
                                            label: 'Users',
                                            value: _teamSize.toString())),
                                    const SizedBox(
                                        width: 85,
                                        child: _StatItem(
                                            label: 'Rating', value: '4.8')),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'ACCOUNT & BUSINESS',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF94A3B8),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _SettingsCard(items: [
                            _SettingsItem(
                              icon: Icons.badge_rounded,
                              label: 'Profile Details',
                              onTap: _openProfileDetailsModal,
                            ),
                            _SettingsItem(
                              icon: Icons.store,
                              label: 'Business Details',
                              onTap: _openBusinessDetailsModal,
                            ),
                            _SettingsItem(
                              icon: Icons.account_balance_wallet,
                              label: 'Billing & Payments',
                              onTap: _openBillingModal,
                            ),
                            _SettingsItem(
                              icon: Icons.group,
                              label: 'Team Members',
                              onTap: _openTeamMembersModal,
                            ),
                          ]),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'PREFERENCES',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF94A3B8),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _SettingsCard(items: [
                            _SettingsItem(
                              icon: Icons.notifications,
                              label: 'Notifications',
                              onTap: _openNotificationsModal,
                            ),
                            _SettingsItem(
                              icon: Icons.shield,
                              label: 'Security & Privacy',
                              onTap: _openSecurityModal,
                            ),
                            _SettingsItem(
                              icon: Icons.image,
                              label: 'Profile Avatar',
                              onTap: _openAvatarModal,
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _ProfileSettingSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final String saveLabel;
  final VoidCallback onClose;
  final VoidCallback onSave;
  final Widget child;

  const _ProfileSettingSheet({
    required this.title,
    required this.icon,
    required this.onClose,
    required this.onSave,
    required this.child,
    this.saveLabel = 'SAVE CHANGES',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (_, t, content) => Transform.translate(
        offset: Offset(0, t * MediaQuery.of(context).size.height * 0.5),
        child: content,
      ),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 30, offset: Offset(0, -4))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFC7D2FE)),
                              ),
                              child: Icon(icon, size: 14, color: _ki),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: _kDk,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: onClose,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: const Icon(Icons.close, size: 14, color: _kMu),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 0, color: Color(0xFFF1F5F9)),
              Flexible(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                      child: child,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white,
                              Colors.white,
                            ],
                          ),
                        ),
                        child: GestureDetector(
                          onTap: onSave,
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: _ki,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: _ki.withOpacity(0.35),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  saveLabel,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.check, size: 14, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarEditSheet extends StatefulWidget {
  final String avatarUrl;
  final String initials;
  final void Function(String avatarUrl, String initials) onSave;

  const _AvatarEditSheet({
    required this.avatarUrl,
    required this.initials,
    required this.onSave,
  });

  @override
  State<_AvatarEditSheet> createState() => _AvatarEditSheetState();
}

class _AvatarEditSheetState extends State<_AvatarEditSheet> {
  late final TextEditingController _urlCtrl;
  late final TextEditingController _initialsCtrl;

  @override
  void initState() {
    super.initState();
    _urlCtrl = TextEditingController(text: widget.avatarUrl);
    _initialsCtrl = TextEditingController(text: widget.initials);
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    _initialsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileSettingSheet(
      title: 'Profile Avatar',
      icon: Icons.camera_alt_rounded,
      onClose: () => Navigator.pop(context),
      onSave: () {
        widget.onSave(_urlCtrl.text.trim(), _initialsCtrl.text.trim());
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 92,
              height: 92,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ClipOval(
                child: Image.network(
                  _urlCtrl.text,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFF1F5F9),
                    alignment: Alignment.center,
                    child: Text(
                      _initialsCtrl.text.trim().isEmpty
                          ? 'NA'
                          : _initialsCtrl.text.trim().toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: _kDk,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const _SheetFieldLabel('Avatar URL'),
          const SizedBox(height: 6),
          _SheetTextField(
            controller: _urlCtrl,
            hint: 'https://example.com/avatar.png',
            icon: Icons.link,
          ),
          const SizedBox(height: 12),
          const _SheetFieldLabel('Fallback Initials'),
          const SizedBox(height: 6),
          _SheetTextField(
            controller: _initialsCtrl,
            hint: 'EP',
            icon: Icons.badge,
          ),
          const SizedBox(height: 10),
          const Text(
            'Tip: If image fails to load, initials will be displayed.',
            style: TextStyle(fontSize: 11, color: _kMu, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailsSheet extends StatefulWidget {
  final String name;
  final String businessName;
  final String planName;
  final void Function(String name, String businessName, String planName) onSave;

  const _ProfileDetailsSheet({
    required this.name,
    required this.businessName,
    required this.planName,
    required this.onSave,
  });

  @override
  State<_ProfileDetailsSheet> createState() => _ProfileDetailsSheetState();
}

class _ProfileDetailsSheetState extends State<_ProfileDetailsSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _businessCtrl;
  late final TextEditingController _planCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _businessCtrl = TextEditingController(text: widget.businessName);
    _planCtrl = TextEditingController(text: widget.planName);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _businessCtrl.dispose();
    _planCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileSettingSheet(
      title: 'Profile Details',
      icon: Icons.badge_rounded,
      onClose: () => Navigator.pop(context),
      onSave: () {
        widget.onSave(_nameCtrl.text, _businessCtrl.text, _planCtrl.text);
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetFieldLabel('Full Name'),
          const SizedBox(height: 6),
          _SheetTextField(
            controller: _nameCtrl,
            hint: 'Your full name',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),
          const _SheetFieldLabel('Business Name'),
          const SizedBox(height: 6),
          _SheetTextField(
            controller: _businessCtrl,
            hint: 'Your company',
            icon: Icons.storefront_outlined,
          ),
          const SizedBox(height: 12),
          const _SheetFieldLabel('Current Plan'),
          const SizedBox(height: 6),
          _SheetTextField(
            controller: _planCtrl,
            hint: 'Plan label',
            icon: Icons.workspace_premium_outlined,
          ),
        ],
      ),
    );
  }
}

class _BusinessDetailsSheet extends StatefulWidget {
  final String email;
  final String phone;
  final String address;
  final void Function(String email, String phone, String address) onSave;

  const _BusinessDetailsSheet({
    required this.email,
    required this.phone,
    required this.address,
    required this.onSave,
  });

  @override
  State<_BusinessDetailsSheet> createState() => _BusinessDetailsSheetState();
}

class _BusinessDetailsSheetState extends State<_BusinessDetailsSheet> {
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.email);
    _phoneCtrl = TextEditingController(text: widget.phone);
    _addressCtrl = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileSettingSheet(
      title: 'Business Details',
      icon: Icons.store_rounded,
      onClose: () => Navigator.pop(context),
      onSave: () {
        widget.onSave(
          _emailCtrl.text.trim(),
          _phoneCtrl.text.trim(),
          _addressCtrl.text.trim(),
        );
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetFieldLabel('Business Email'),
          const SizedBox(height: 6),
          _SheetTextField(
            controller: _emailCtrl,
            hint: 'business@example.com',
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: 12),
          const _SheetFieldLabel('Phone'),
          const SizedBox(height: 6),
          _SheetTextField(
            controller: _phoneCtrl,
            hint: '+1 555 ...',
            icon: Icons.phone_outlined,
          ),
          const SizedBox(height: 12),
          const _SheetFieldLabel('Address'),
          const SizedBox(height: 6),
          _SheetTextField(
            controller: _addressCtrl,
            hint: 'City, Country',
            icon: Icons.location_on_outlined,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _BillingPaymentsSheet extends StatefulWidget {
  final String accountName;
  final String paymentMethod;
  final String billingCycle;
  final void Function(String name, String method, String cycle) onSave;

  const _BillingPaymentsSheet({
    required this.accountName,
    required this.paymentMethod,
    required this.billingCycle,
    required this.onSave,
  });

  @override
  State<_BillingPaymentsSheet> createState() => _BillingPaymentsSheetState();
}

class _BillingPaymentsSheetState extends State<_BillingPaymentsSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _methodCtrl;
  late String _cycle;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.accountName);
    _methodCtrl = TextEditingController(text: widget.paymentMethod);
    _cycle = widget.billingCycle;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _methodCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileSettingSheet(
      title: 'Billing & Payments',
      icon: Icons.account_balance_wallet_rounded,
      onClose: () => Navigator.pop(context),
      onSave: () {
        widget.onSave(_nameCtrl.text.trim(), _methodCtrl.text.trim(), _cycle);
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetFieldLabel('Account Name'),
          const SizedBox(height: 6),
          _SheetTextField(
            controller: _nameCtrl,
            hint: 'Company billing account',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          const _SheetFieldLabel('Default Payment Method'),
          const SizedBox(height: 6),
          _SheetTextField(
            controller: _methodCtrl,
            hint: 'Visa •••• 4592',
            icon: Icons.credit_card_outlined,
          ),
          const SizedBox(height: 12),
          const _SheetFieldLabel('Billing Cycle'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButton<String>(
              value: _cycle,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(12),
              items: const [
                DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                DropdownMenuItem(value: 'Quarterly', child: Text('Quarterly')),
                DropdownMenuItem(value: 'Yearly', child: Text('Yearly')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _cycle = value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamMembersSheet extends StatefulWidget {
  final int teamSize;
  final String inviteEmail;
  final void Function(int size, String inviteEmail) onSave;

  const _TeamMembersSheet({
    required this.teamSize,
    required this.inviteEmail,
    required this.onSave,
  });

  @override
  State<_TeamMembersSheet> createState() => _TeamMembersSheetState();
}

class _TeamMembersSheetState extends State<_TeamMembersSheet> {
  late int _size;
  late final TextEditingController _inviteCtrl;

  @override
  void initState() {
    super.initState();
    _size = widget.teamSize;
    _inviteCtrl = TextEditingController(text: widget.inviteEmail);
  }

  @override
  void dispose() {
    _inviteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileSettingSheet(
      title: 'Team Members',
      icon: Icons.group_rounded,
      onClose: () => Navigator.pop(context),
      onSave: () {
        widget.onSave(_size, _inviteCtrl.text.trim());
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetFieldLabel('Current Team Size'),
          const SizedBox(height: 6),
          Row(
            children: [
              _CounterButton(icon: Icons.remove, onTap: () {
                if (_size > 1) setState(() => _size--);
              }),
              Expanded(
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    '$_size members',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: _kDk,
                    ),
                  ),
                ),
              ),
              _CounterButton(icon: Icons.add, onTap: () => setState(() => _size++)),
            ],
          ),
          const SizedBox(height: 12),
          const _SheetFieldLabel('Invite by Email'),
          const SizedBox(height: 6),
          _SheetTextField(
            controller: _inviteCtrl,
            hint: 'new.member@company.com',
            icon: Icons.person_add_alt_1,
          ),
        ],
      ),
    );
  }
}

class _NotificationsSheet extends StatefulWidget {
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final void Function(bool push, bool email, bool sms) onSave;

  const _NotificationsSheet({
    required this.pushEnabled,
    required this.emailEnabled,
    required this.smsEnabled,
    required this.onSave,
  });

  @override
  State<_NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<_NotificationsSheet> {
  late bool _push;
  late bool _email;
  late bool _sms;

  @override
  void initState() {
    super.initState();
    _push = widget.pushEnabled;
    _email = widget.emailEnabled;
    _sms = widget.smsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileSettingSheet(
      title: 'Notifications',
      icon: Icons.notifications_active_rounded,
      onClose: () => Navigator.pop(context),
      onSave: () {
        widget.onSave(_push, _email, _sms);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          _SwitchTile(
            icon: Icons.notifications,
            label: 'Push Notifications',
            value: _push,
            onChanged: (v) => setState(() => _push = v),
          ),
          const SizedBox(height: 8),
          _SwitchTile(
            icon: Icons.email,
            label: 'Email Notifications',
            value: _email,
            onChanged: (v) => setState(() => _email = v),
          ),
          const SizedBox(height: 8),
          _SwitchTile(
            icon: Icons.sms,
            label: 'SMS Notifications',
            value: _sms,
            onChanged: (v) => setState(() => _sms = v),
          ),
        ],
      ),
    );
  }
}

class _SecurityPrivacySheet extends StatefulWidget {
  final bool twoFactorEnabled;
  final bool biometricEnabled;
  final String sessionTimeout;
  final void Function(bool twoFactor, bool biometric, String timeout) onSave;

  const _SecurityPrivacySheet({
    required this.twoFactorEnabled,
    required this.biometricEnabled,
    required this.sessionTimeout,
    required this.onSave,
  });

  @override
  State<_SecurityPrivacySheet> createState() => _SecurityPrivacySheetState();
}

class _SecurityPrivacySheetState extends State<_SecurityPrivacySheet> {
  late bool _twoFactor;
  late bool _biometric;
  late String _timeout;

  @override
  void initState() {
    super.initState();
    _twoFactor = widget.twoFactorEnabled;
    _biometric = widget.biometricEnabled;
    _timeout = widget.sessionTimeout;
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileSettingSheet(
      title: 'Security & Privacy',
      icon: Icons.shield_rounded,
      onClose: () => Navigator.pop(context),
      onSave: () {
        widget.onSave(_twoFactor, _biometric, _timeout);
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SwitchTile(
            icon: Icons.verified_user,
            label: 'Two-factor authentication',
            value: _twoFactor,
            onChanged: (v) => setState(() => _twoFactor = v),
          ),
          const SizedBox(height: 8),
          _SwitchTile(
            icon: Icons.fingerprint,
            label: 'Biometric unlock',
            value: _biometric,
            onChanged: (v) => setState(() => _biometric = v),
          ),
          const SizedBox(height: 12),
          const _SheetFieldLabel('Session Timeout'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButton<String>(
              value: _timeout,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(12),
              items: const [
                DropdownMenuItem(value: '15 min', child: Text('15 min')),
                DropdownMenuItem(value: '30 min', child: Text('30 min')),
                DropdownMenuItem(value: '1 hour', child: Text('1 hour')),
                DropdownMenuItem(value: '4 hours', child: Text('4 hours')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _timeout = value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetFieldLabel extends StatelessWidget {
  final String text;
  const _SheetFieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: _kMu,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _SheetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _SheetTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: _kDk,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: _kMu,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          prefixIcon: Icon(icon, size: 18, color: _kMu),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _ki),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _kDk,
              ),
            ),
          ),
          Switch(
            value: value,
            activeColor: _ki,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Icon(icon, size: 18, color: _ki),
      ),
    );
  }
}

// Small header icon button used in the header
class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final Color tint;
  const _HeaderIcon({required this.icon, required this.tint});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.white),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Icon(icon, size: 15, color: tint),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsCard({required this.items});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12)]),
      child: Column(
        children: items.map((it) => Column(children: [ListTile(
          leading: Container(width:40, height:40, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: Icon(it.icon, color: _ki)),
          title: Text(it.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _kDk)),
          trailing: const Icon(Icons.chevron_right, size: 18, color: Color(0xFFCBD5E1)),
          onTap: () {},
        ), const Divider(height:0, indent: 64, color: Color(0xFFF1F5F9))])).toList(),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  const _SettingsItem({required this.icon, required this.label});
}

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem({required this.label, required this.value});

  String _abbreviateNumber(String input) {
    String numStr = input.replaceAll('\$', '').replaceAll(',', '');
    double? num = double.tryParse(numStr);
    if (num == null || num < 1000) return input;
    double k = num / 1000;
    String formatted = k % 1 == 0 ? '${k.toInt()}' : k.toStringAsFixed(1);
    return '\$$formatted' + 'k';
  }

  @override
  Widget build(BuildContext context) {
    String displayValue = label == 'Revenue' ? _abbreviateNumber(value) : (label == 'Users' ? _abbreviateNumber(value.replaceAll(',', '')) : value);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_ki.withOpacity(0.15), _kid.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _ki.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(displayValue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _kDk)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final bool isCenter;

  const _PlaceholderPage({
    required this.icon,
    required this.label,
    required this.sub,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _ki.withOpacity(0.08),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _ki.withOpacity(0.15)),
              ),
              child: Icon(icon, size: 32, color: _ki),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _kDk,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _kMu,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
