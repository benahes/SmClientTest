import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard_screen.dart'; // GlassCard

// ── Color tokens ─────────────────────────────────────────────────────────────
const _ki  = Color(0xFF6366F1);
const _kid = Color(0xFF4F46E5);
const _kDk = Color(0xFF0F172A);
const _kMu = Color(0xFF94A3B8);
const _ke  = Color(0xFF10B981);
const _ka  = Color(0xFFF59E0B);
const _kSb = Color(0xFF64748B);

// ── Platform colour map ───────────────────────────────────────────────────────
const _whatsapp = Color(0xFF25D366);
const _telegram = Color(0xFF229ED9);

// ═══════════════════════════════════════════════════════════════════════════════
//  DATA
// ═══════════════════════════════════════════════════════════════════════════════

enum _BotStatus { active, paused, inactive }
enum _Platform { whatsapp, telegram }

class _BotData {
  final String name;
  final String handle;
  final _Platform platform;
  final _BotStatus status;
  final int chatsToday;
  final String aiHandled;   // e.g. "98%"
  bool aiEnabled;

  _BotData({
    required this.name,
    required this.handle,
    required this.platform,
    required this.status,
    required this.chatsToday,
    required this.aiHandled,
    required this.aiEnabled,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
//  SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  // Filter state: null = All
  _Platform? _filter;

  final _bots = [
    _BotData(
      name: 'Main Sales Bot',
      handle: '+1 (555) 019-8372',
      platform: _Platform.whatsapp,
      status: _BotStatus.active,
      chatsToday: 1240,
      aiHandled: '98%',
      aiEnabled: true,
    ),
    _BotData(
      name: 'Support Assistant',
      handle: '@MyStoreAgent',
      platform: _Platform.telegram,
      status: _BotStatus.active,
      chatsToday: 412,
      aiHandled: '85%',
      aiEnabled: true,
    ),
    _BotData(
      name: 'Backup Number',
      handle: '+1 (555) 991-0021',
      platform: _Platform.whatsapp,
      status: _BotStatus.paused,
      chatsToday: 14,
      aiHandled: '0%',
      aiEnabled: false,
    ),
  ];

  List<_BotData> get _visible => _filter == null
      ? _bots
      : _bots.where((b) => b.platform == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFFEDF1F8),
        body: Stack(children: [

          // ── Mesh Orbs ────────────────────────────────────────────────────────
          Positioned(
            top: -100, left: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 350, height: 350,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(99, 102, 241, 0.20)),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25, right: -150,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(
                width: 450, height: 450,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(16, 185, 129, 0.16)),
              ),
            ),
          ),
          Positioned(
            bottom: -50, left: MediaQuery.of(context).size.width * 0.1,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(
                width: 400, height: 400,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(99, 102, 241, 0.18)),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────────
          Column(children: [

            // ── Header bar ───────────────────────────────────────────────────
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.18),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: const Icon(Icons.chevron_left_rounded, size: 18, color: Colors.white),
                    ),
                  ),

                  // Title
                  const Text(
                    'CHANNELS',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2),
                  ),

                  // Add button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.18),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: const Icon(Icons.add, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // ── Search + filter pills ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Search
                GlassCard(
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.zero,
                  leftBorderWidth: 0,
                  child: SizedBox(
                    height: 34,
                    child: Row(children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.search_rounded, size: 13, color: _kMu),
                      const SizedBox(width: 7),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search bots or numbers...',
                            hintStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _kMu),
                            border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _kDk),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ]),
                  ),
                ),
                const SizedBox(height: 8),

                // Filter pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(children: [
                    _FilterPill(label: 'All Bots', active: _filter == null, onTap: () => setState(() => _filter = null)),
                    const SizedBox(width: 6),
                    _FilterPill(
                      label: 'WhatsApp',
                      active: _filter == _Platform.whatsapp,
                      faIcon: FontAwesomeIcons.whatsapp,
                      iconColor: _whatsapp,
                      onTap: () => setState(() => _filter = _Platform.whatsapp),
                    ),
                    const SizedBox(width: 6),
                    _FilterPill(
                      label: 'Telegram',
                      active: _filter == _Platform.telegram,
                      faIcon: FontAwesomeIcons.telegram,
                      iconColor: _telegram,
                      onTap: () => setState(() => _filter = _Platform.telegram),
                    ),
                  ]),
                ),
              ]),
            ),

            // ── Bot list ─────────────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                itemCount: _visible.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final bot = _visible[i];
                  return _BotCard(
                    bot: bot,
                    onToggle: (v) => setState(() => bot.aiEnabled = v),
                  );
                },
              ),
            ),
          ]),

          // ── Sticky "Connect" CTA ─────────────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFFEDF1F8), Color(0x00EDF1F8)],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFA5B4FC), width: 1.2),
                    boxShadow: [BoxShadow(color: _ki.withOpacity(0.09), blurRadius: 14, offset: const Offset(0, 4))],
                  ),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.add_rounded, size: 14, color: _ki),
                    SizedBox(width: 6),
                    Text(
                      'Connect New Channel',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _ki, letterSpacing: 0.3),
                    ),
                  ]),
                ),
              ),
            ),
          ),

        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  BOT CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _BotCard extends StatelessWidget {
  final _BotData bot;
  final ValueChanged<bool> onToggle;
  const _BotCard({required this.bot, required this.onToggle});

  Color get _platformColor => bot.platform == _Platform.whatsapp ? _whatsapp : _telegram;
  Color get _platformBg    => bot.platform == _Platform.whatsapp
      ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF);
  Widget get _platformIconWidget => bot.platform == _Platform.whatsapp
      ? const FaIcon(FontAwesomeIcons.whatsapp, size: 16)
      : const FaIcon(FontAwesomeIcons.telegram, size: 16);

  @override
  Widget build(BuildContext context) {
    final isActive = bot.status == _BotStatus.active;
    final isPaused = bot.status == _BotStatus.paused;

    return GlassCard(
      borderRadius: BorderRadius.circular(18),
      padding: EdgeInsets.zero,
      leftBorderColor: isActive ? _platformColor : null,
      leftBorderWidth: 3,
      child: Opacity(
        opacity: isPaused ? 0.82 : 1.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Top row: info + status ──────────────────────────────────────
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Platform icon
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? _platformBg : const Color(0xFFF1F5F9),
                  border: Border.all(color: isActive ? _platformColor.withOpacity(0.2) : const Color(0xFFE2E8F0)),
                ),
                child: Center(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      isActive ? _platformColor : _kMu,
                      BlendMode.srcIn,
                    ),
                    child: _platformIconWidget,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Name + handle
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(bot.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kDk, letterSpacing: -0.2)),
                  const SizedBox(height: 1),
                  Text(bot.handle, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: _kMu)),
                ]),
              ),

              // Status badge + menu
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.more_vert_rounded, size: 14, color: _kMu),
                  ),
                ),
                _StatusBadge(status: bot.status),
              ]),
            ]),

            // ── Divider ──────────────────────────────────────────────────────
            const SizedBox(height: 8),
            Container(height: 1, color: const Color(0x0F000000)),
            const SizedBox(height: 8),

            // ── Stats row + toggle ────────────────────────────────────────────
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              // stats
              Row(children: [
                _StatPill(
                  label: 'CHATS TODAY',
                  value: _fmt(bot.chatsToday),
                  valueColor: isActive ? _kDk : _kMu,
                ),
                Container(width: 1, height: 28, color: const Color(0x0F000000), margin: const EdgeInsets.symmetric(horizontal: 10)),
                _StatPill(
                  label: 'AI HANDLED',
                  value: bot.aiHandled,
                  valueColor: isActive ? const Color(0xFF7C3AED) : _kMu,
                  suffix: isActive ? Icons.auto_awesome_rounded : null,
                ),
              ]),

              // AI toggle
              GestureDetector(
                onTap: () => onToggle(!bot.aiEnabled),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36, height: 20,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: bot.aiEnabled
                        ? const LinearGradient(colors: [_ki, Color(0xFFA855F7)])
                        : const LinearGradient(colors: [Color(0xFFE2E8F0), Color(0xFFE2E8F0)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    alignment: bot.aiEnabled ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 16, height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                      ),
                    ),
                  ),
                ),
              ),
            ]),

          ]),
        ),
      ),
    );
  }

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

// ═══════════════════════════════════════════════════════════════════════════════
//  STATUS BADGE
// ═══════════════════════════════════════════════════════════════════════════════

class _StatusBadge extends StatelessWidget {
  final _BotStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color dot;
    final Color bg;
    final Color border;
    final Color text;
    final String label;
    final bool pulse;

    switch (status) {
      case _BotStatus.active:
        dot = _ke; bg = const Color(0xFFECFDF5); border = const Color(0xFFD1FAE5);
        text = const Color(0xFF059669); label = 'ACTIVE'; pulse = true;
        break;
      case _BotStatus.paused:
        dot = _ka; bg = const Color(0xFFFFFBEB); border = const Color(0xFFFDE68A);
        text = const Color(0xFFD97706); label = 'AI PAUSED'; pulse = false;
        break;
      case _BotStatus.inactive:
        dot = _kMu; bg = const Color(0xFFF8FAFC); border = const Color(0xFFE2E8F0);
        text = _kMu; label = 'INACTIVE'; pulse = false;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(6), border: Border.all(color: border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _PulseDot(color: dot, pulse: pulse),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.w900, color: text, letterSpacing: 0.4)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  PULSE DOT
// ═══════════════════════════════════════════════════════════════════════════════

class _PulseDot extends StatefulWidget {
  final Color color;
  final bool pulse;
  const _PulseDot({required this.color, required this.pulse});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.pulse) {
      return Container(width: 6, height: 6, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle));
    }
    return FadeTransition(
      opacity: _anim,
      child: Container(width: 6, height: 6, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  STAT PILL
// ═══════════════════════════════════════════════════════════════════════════════

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final IconData? suffix;

  const _StatPill({
    required this.label,
    required this.value,
    required this.valueColor,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 0.8)),
      const SizedBox(height: 2),
      Row(children: [
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: valueColor, height: 1)),
        if (suffix != null) ...[
          const SizedBox(width: 3),
          Icon(suffix, size: 9, color: valueColor),
        ],
      ]),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  FILTER PILL
// ═══════════════════════════════════════════════════════════════════════════════

class _FilterPill extends StatelessWidget {
  final String label;
  final bool active;
  final IconData? icon;
  final IconData? faIcon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
    this.faIcon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final iconW = faIcon != null
        ? FaIcon(faIcon!, size: 9, color: active ? Colors.white : iconColor)
        : icon != null
            ? Icon(icon, size: 9, color: active ? Colors.white : iconColor)
            : null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? _ki : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? _ki : const Color(0xFFE2E8F0)),
          boxShadow: active
              ? [BoxShadow(color: _ki.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))]
              : [const BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 1))],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (iconW != null) ...[
            iconW,
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              color: active ? Colors.white : _kSb,
              letterSpacing: 0.2,
            ),
          ),
        ]),
      ),
    );
  }
}
