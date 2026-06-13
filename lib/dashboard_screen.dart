import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'main_shell.dart';

// ── Color tokens (identical to login page) ───────────────────────────────────
const _ki  = Color(0xFF6366F1);
const _kid = Color(0xFF4F46E5);
const _ke  = Color(0xFF10B981);
const _ka  = Color(0xFFF59E0B);
const _kr  = Color(0xFFF43F5E);
const _kDk = Color(0xFF0F172A);
const _ks8 = Color(0xFF1E293B);
const _kMu = Color(0xFF94A3B8);
const _kSb = Color(0xFF64748B);
const _kBd = Color(0xFFE2E8F0);

// ═══════════════════════════════════════════════════════════════════════════════
//  DASHBOARD SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  bool _showWithdrawal = false;

  void _showWithdrawalModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext context) => _WithdrawalSheet(
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: const Color(0xFFEDF1F8),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          // ── Mesh Background Orbs ──────────────────────────────────────────
          Positioned(
            top: -100, left: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(width: 350, height: 350, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(99, 102, 241, 0.20))),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25, right: -150,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(width: 450, height: 450, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(16, 185, 129, 0.16))),
            ),
          ),
          Positioned(
            bottom: -50, left: MediaQuery.of(context).size.width * 0.1,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(width: 400, height: 400, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(99, 102, 241, 0.18))),
            ),
          ),
        // Main content – dimmed when modal open
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _showWithdrawal ? 0.45 : 1.0,
          child: IgnorePointer(
            ignoring: _showWithdrawal,
            child: _DashBody(
              onWithdraw: () {
                setState(() => _showWithdrawal = true);
                _showWithdrawalModal();
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) setState(() => _showWithdrawal = false);
                });
              },
            ),
          ),
        ),
      ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  DASHBOARD BODY
// ═══════════════════════════════════════════════════════════════════════════════

class _DashBody extends StatefulWidget {
  final VoidCallback onWithdraw;
  const _DashBody({required this.onWithdraw});
  @override
  State<_DashBody> createState() => _DashBodyState();
}

class _DashBodyState extends State<_DashBody> {
  bool _weeklyMode = true;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Column(children: [
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
        child: _buildHeaderRow(),
      ),
      Expanded(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildSearch(),
            _RevenueCard(onWithdraw: widget.onWithdraw),
            const SizedBox(height: 8),
            _buildKpiRow(),
            _buildQuickActions(),
            _RevenueChart(weekly: _weeklyMode,
              onToggle: (v) => setState(() => _weeklyMode = v)),
            _buildActivities(),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    ]);
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeaderRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        GestureDetector(
          onTap: () => MainShellState.navigateToProfile(),
          child: Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8)],
            ),
            child: ClipOval(
              child: Image.network('https://i.pravatar.cc/100?img=11',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.white24,
                  child: const Center(child: Text('JD',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white))),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Welcome back,',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70, height: 1)),
          Text('John Doe 👋',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.2)),
        ]),
      ]),
      Stack(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white30),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
          ),
          child: const Icon(Icons.notifications_outlined, size: 15, color: Colors.white),
        ),
        Positioned(top: 6, right: 6, child: Container(
          width: 8, height: 8,
          decoration: BoxDecoration(
            color: _kr, shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
        )),
      ]),
    ]);
  }

  // ── Search bar ──────────────────────────────────────────────────────────────
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
      child: GlassCard(
        borderRadius: BorderRadius.circular(8),
        padding: EdgeInsets.zero,
        child: Container(
          height: 36,

        child: const Row(children: [
          SizedBox(width: 10),
          Icon(Icons.search, size: 14, color: _kMu),
          SizedBox(width: 8),
          Expanded(child: TextField(
            decoration: InputDecoration(
              hintText: 'Search analytics, customers, or actions...',
              hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _kMu),
              border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _kDk),
          )),
          SizedBox(width: 10),
        ]),
      ),
      ),
    );
  }

  // ── KPI row ─────────────────────────────────────────────────────────────────
  Widget _buildKpiRow() {
    return SizedBox(
      height: 88,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          _KpiCard(label: 'AI Sales',  value: '342',   trend: '+8%',  trending: true,
            accentColor: _ka, icon: Icons.smart_toy_outlined,
            points: [0.75, 0.583, 0.333, 0.167]),
          SizedBox(width: 8),
          _KpiCard(label: 'Orders',    value: '1,028', trend: '+24%', trending: true,
            accentColor: _ke, icon: Icons.inventory_2_outlined,
            points: [0.667, 0.5, 0.417, 0.167]),
          SizedBox(width: 8),
          _KpiCard(label: 'Bookings',  value: '84',    trend: '-2%',  trending: false,
            accentColor: _kr, icon: Icons.calendar_today_outlined,
            points: [0.25, 0.667, 0.5, 0.833]),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  // ── Quick Actions ────────────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    const actions = [
      _QA(icon: Icons.inventory_2_outlined,  label: 'Add\nProduct',       hi: false),
      _QA(icon: Icons.receipt_long_outlined,  label: 'Create\nInvoice',   hi: false),
      _QA(icon: Icons.campaign_outlined,      label: 'Send\nBroadcast',   hi: false),
      _QA(icon: Icons.calendar_month_outlined,label: 'New\nBooking',      hi: false),
      _QA(icon: Icons.auto_awesome,           label: 'Train\nAI',         hi: true),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('QUICK ACTIONS',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((a) => _QuickActionBtn(a)).toList()),
      ]),
    );
  }

  // ── Activities ──────────────────────────────────────────────────────────────
  Widget _buildActivities() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('RECENT ACTIVITIES',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
          Text('View All',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _ki)),
        ]),
        const SizedBox(height: 8),
        GlassCard(
          borderRadius: BorderRadius.circular(12),
          child: Column(children: const [
            _ActivityItem(ic: _ka, bg: Color(0xFFFFFBEB),
              title: 'AI closed a sale!',
              sub: 'SmClient AI converted a lead into a \$199 Pro Subscription.',
              time: 'Just now', icon: Icons.smart_toy_outlined),
            Divider(height: 0, indent: 54, color: Color(0xFFF1F5F9)),
            _ActivityItem(ic: _ke, bg: Color(0xFFF0FDF4),
              title: 'Payment Received',
              sub: 'Received \$49.00 from Sarah Jenkins via Bank Transfer.',
              time: '2h ago', icon: Icons.south_rounded),
            Divider(height: 0, indent: 54, color: Color(0xFFF1F5F9)),
            _ActivityItem(ic: _ki, bg: Color(0xFFEEF2FF),
              title: 'New Consultation',
              sub: 'Mike Ross booked a 30-min strategy call for Oct 12th.',
              time: 'Yesterday', icon: Icons.calendar_today_outlined),
          ]),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  GLASS CARD (SURFACE)
// ═══════════════════════════════════════════════════════════════════════════════

class GlassCard extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? leftBorderColor;
  final double leftBorderWidth;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.leftBorderColor,
    this.leftBorderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(12);
    return Container(
      decoration: BoxDecoration(
        borderRadius: br,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(15, 23, 42, 0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: br,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(255, 255, 255, 0.95),
                  Color.fromRGBO(255, 255, 255, 0.60),
                ],
              ),
              borderRadius: br,
              border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.8), width: 1),
            ),
            child: Stack(
              children: [
                Container(
                  padding: padding,
                  decoration: BoxDecoration(
                    borderRadius: br,
                    border: const Border(
                      top: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.9), width: 1),
                    ),
                  ),
                  child: child,
                ),
                if (leftBorderColor != null)
                  Positioned(
                    left: 0, top: 0, bottom: 0,
                    child: Container(width: leftBorderWidth, color: leftBorderColor!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  REVENUE CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _RevenueCard extends StatelessWidget {
  final VoidCallback onWithdraw;
  const _RevenueCard({required this.onWithdraw});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: GlassCard(
        borderRadius: BorderRadius.circular(12),
        leftBorderColor: _ki,
        leftBorderWidth: 2.5,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 20, height: 20,
                    decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.account_balance_wallet_outlined, size: 11, color: _ki)),
                  const SizedBox(width: 6),
                  const Text('TOTAL REVENUE',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 0.8)),
                ]),
                const SizedBox(height: 4),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const Text('\$14,592',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _kDk,
                      letterSpacing: -0.5, height: 1)),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBBF7D0))),
                    child: const Row(children: [
                      Icon(Icons.trending_up, size: 8, color: _ke),
                      SizedBox(width: 2),
                      Text('12%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _ke)),
                    ]),
                  ),
                ]),
              ]),
              GestureDetector(
                onTap: onWithdraw,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFA5B4FC)),
                    boxShadow: [BoxShadow(color: _ki.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Row(children: [
                    Container(width: 24, height: 24,
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFC7D2FE))),
                      child: const Icon(Icons.account_balance_outlined, size: 11, color: _ki)),
                    const SizedBox(width: 6),
                    const Text('WITHDRAW',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _ki, letterSpacing: 1.5)),
                  ]),
                ),
              ),
            ]),
          ),
          SizedBox(height: 28,
            child: CustomPaint(
              painter: _SparklinePainter(points: const [0.667, 0.533, 0.40, 0.533, 0.20], color: _ki),
              size: Size.infinite)),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  KPI CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _KpiCard extends StatelessWidget {
  final String label, value, trend;
  final bool trending;
  final Color accentColor;
  final IconData icon;
  final List<double> points;

  const _KpiCard({required this.label, required this.value, required this.trend,
    required this.trending, required this.accentColor, required this.icon, required this.points});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 105,
      child: GlassCard(
        borderRadius: BorderRadius.circular(12),
        leftBorderColor: accentColor,
        leftBorderWidth: 2,
        child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(width: 20, height: 20,
                decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Icon(icon, size: 10, color: accentColor)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: trending ? const Color(0xFFF0FDF4) : const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(5)),
                child: Row(children: [
                   Icon(trending ? Icons.trending_up : Icons.trending_down,
                    size: 7, color: trending ? _ke : _kr),
                  const SizedBox(width: 1),
                  Text(trend, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                    color: trending ? _ke : _kr)),
                ]),
              ),
            ]),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kMu)),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _kDk, height: 1.2)),
          ]),
        ),
        Expanded(child: CustomPaint(
          painter: _SparklinePainter(points: points, color: accentColor),
          size: Size.infinite)),
      ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  QUICK ACTION BUTTON
// ═══════════════════════════════════════════════════════════════════════════════

class _QA { // data class
  final IconData icon; final String label; final bool hi;
  const _QA({required this.icon, required this.label, required this.hi});
}

class _QuickActionBtn extends StatelessWidget {
  final _QA a;
  const _QuickActionBtn(this.a);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(children: [
        a.hi
          ? Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: _ki, borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _kid),
                boxShadow: [BoxShadow(color: _ki.withOpacity(0.28), blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: Icon(a.icon, size: 20, color: Colors.white),
            )
          : SizedBox(
              width: 48, height: 48,
              child: GlassCard(
                borderRadius: BorderRadius.circular(8),
                child: Center(child: Icon(a.icon, size: 20, color: _kSb)),
              ),
            ),
        const SizedBox(height: 5),
        Text(a.label, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, height: 1.2,
            color: a.hi ? _ki : _kDk)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  REVENUE CHART
// ═══════════════════════════════════════════════════════════════════════════════

class _RevenueChart extends StatelessWidget {
  final bool weekly;
  final ValueChanged<bool> onToggle;
  const _RevenueChart({required this.weekly, required this.onToggle});

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return GestureDetector(onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4)] : null),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
          color: active ? _kDk : _kMu))));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: GlassCard(
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('REVENUE GROWTH',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _kBd)),
              child: Row(children: [
                _tab('Weekly', weekly, () => onToggle(true)),
                _tab('Monthly', !weekly, () => onToggle(false)),
              ])),
          ]),
          const SizedBox(height: 8),
          SizedBox(height: 70, child: CustomPaint(painter: _ChartPainter(), size: Size.infinite)),
          const SizedBox(height: 6),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Mon', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
            Text('Tue', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
            Text('Wed', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
            Text('Thu', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
            Text('Fri', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
            Text('Sat', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
            Text('Sun', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
          ]),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  ACTIVITY ITEM
// ═══════════════════════════════════════════════════════════════════════════════

class _ActivityItem extends StatelessWidget {
  final Color ic, bg;
  final String title, sub, time;
  final IconData icon;
  const _ActivityItem({required this.ic, required this.bg, required this.title,
    required this.sub, required this.time, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 28, height: 28,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle,
            border: Border.all(color: ic.withOpacity(0.2))),
          child: Icon(icon, size: 13, color: ic)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kDk)),
            Text(time, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _kMu)),
          ]),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kSb, height: 1.3)),
        ])),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  WITHDRAWAL SHEET
// ═══════════════════════════════════════════════════════════════════════════════

class _WithdrawalSheet extends StatefulWidget {
  final VoidCallback onClose;
  const _WithdrawalSheet({required this.onClose});
  @override
  State<_WithdrawalSheet> createState() => _WithdrawalSheetState();
}

class _WithdrawalSheetState extends State<_WithdrawalSheet> {
  bool _bankSelected = true;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (_, t, child) =>
          Transform.translate(offset: Offset(0, t * MediaQuery.of(context).size.height * 0.5), child: child),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 30, offset: Offset(0, -4))],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // ── Header ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Column(children: [
                Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: _kBd, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Withdraw Funds',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kDk, letterSpacing: -0.3)),
                  GestureDetector(onTap: widget.onClose,
                    child: Container(width: 28, height: 28,
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC),
                        shape: BoxShape.circle, border: Border.all(color: _kBd)),
                      child: const Icon(Icons.close, size: 14, color: _kMu))),
                ]),
              ]),
            ),
            const Divider(height: 0, color: Color(0xFFF1F5F9)),
            // ── Scrollable content + sticky button ───────────────────────────
            Flexible(child: Stack(children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Balance tile
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(children: [
                      Container(color: const Color(0xFFF0FDF4), padding: const EdgeInsets.all(10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(children: [
                            Container(width: 24, height: 24,
                              decoration: BoxDecoration(color: const Color(0xFFD1FAE5),
                                shape: BoxShape.circle, border: Border.all(color: const Color(0xFF6EE7B7))),
                              child: const Icon(Icons.account_balance_wallet_outlined, size: 11, color: _ke)),
                            const SizedBox(width: 8),
                            const Text('AVAILABLE TO WITHDRAW',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kDk, letterSpacing: 0.8)),
                          ]),
                          const Text('\$14,592.00',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _ke)),
                        ])),
                      Container(color: const Color(0xFFF8FAFC), padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(children: [
                            Container(width: 20, height: 20,
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                                border: Border.all(color: _kBd)),
                              child: const Icon(Icons.lock_outline, size: 9, color: _ka)),
                            const SizedBox(width: 8),
                            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('PENDING CLEARANCE',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 0.8)),
                              Text('Not yet available for withdrawal',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _kMu)),
                            ]),
                          ]),
                          const Text('\$1,250.00',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: _kMu)),
                        ])),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  // Amount
                  const Text('WITHDRAWAL AMOUNT',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
                  const SizedBox(height: 6),
                  Container(height: 44,
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12), border: Border.all(color: _kBd)),
                    child: Row(children: [
                      const SizedBox(width: 12),
                      const Text('\$', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _kDk)),
                      const SizedBox(width: 4),
                      const Expanded(child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: TextStyle(color: _kMu, fontWeight: FontWeight.w700),
                          border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _kDk))),
                      Container(margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(8)),
                        child: const Text('MAX',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _ki, letterSpacing: 1))),
                    ])),
                  const SizedBox(height: 14),
                  // Method toggle
                  const Text('WITHDRAWAL METHOD',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
                  const SizedBox(height: 6),
                  Container(padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14), border: Border.all(color: _kBd)),
                    child: Row(children: [
                      _methodTab('Bank Transfer', Icons.account_balance_outlined, _bankSelected, _ki, () => setState(() => _bankSelected = true)),
                      _methodTab('Crypto', Icons.currency_bitcoin, !_bankSelected, _ka, () => setState(() => _bankSelected = false)),
                    ])),
                  const SizedBox(height: 14),
                  // Account
                  const Text('SEND TO ACCOUNT',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
                  const SizedBox(height: 6),
                  Container(padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF0F4FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _ki, width: 1.5)),
                    child: Row(children: [
                      Container(width: 32, height: 32,
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFC7D2FE))),
                        child: const Icon(Icons.account_balance_outlined, size: 14, color: _ki)),
                      const SizedBox(width: 10),
                      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Chase Bank USA',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kDk)),
                        Text('Account ending in 4592',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _kMu)),
                      ])),
                      Container(width: 16, height: 16,
                        decoration: const BoxDecoration(color: _ki, shape: BoxShape.circle),
                        child: const Icon(Icons.check, size: 10, color: Colors.white)),
                    ])),
                  const SizedBox(height: 8),
                  Container(height: 38,
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12), border: Border.all(color: _kBd)),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.add, size: 12, color: _kMu), SizedBox(width: 6),
                      Text('ADD NEW BANK ACCOUNT',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 0.8)),
                    ])),
                  const SizedBox(height: 12),
                  const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.lock_outline, size: 9, color: _kMu), SizedBox(width: 5),
                    Text('SECURED BY 256-BIT SSL',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _kMu, letterSpacing: 1)),
                  ]),
                ]),
              ),
              // Sticky confirm button
              Positioned(bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.white.withOpacity(0), Colors.white, Colors.white])),
                  child: GestureDetector(onTap: widget.onClose,
                    child: Container(height: 44,
                      decoration: BoxDecoration(color: _ki,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: _ki.withOpacity(0.35), blurRadius: 15, offset: const Offset(0, 6))]),
                      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('CONFIRM WITHDRAWAL',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                      ])))),
              ),
            ])),
          ]),
        ),
      ),
    );
  }

  Widget _methodTab(String label, IconData icon, bool active, Color iconColor, VoidCallback onTap) {
    return Expanded(child: GestureDetector(onTap: onTap,
      child: Container(height: 36,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4)] : null),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 14, color: active ? iconColor : _kMu), const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
            color: active ? _kDk : _kMu)),
        ]))));
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  PAINTERS
// ═══════════════════════════════════════════════════════════════════════════════

class _SparklinePainter extends CustomPainter {
  final List<double> points; // normalized y: 0=top, 1=bottom
  final Color color;
  const _SparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final pts = List.generate(points.length,
      (i) => Offset(i / (points.length - 1) * size.width, points[i] * size.height));

    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final m = Offset((pts[i].dx + pts[i + 1].dx) / 2, (pts[i].dy + pts[i + 1].dy) / 2);
      path.quadraticBezierTo(pts[i].dx, pts[i].dy, m.dx, m.dy);
    }
    path.lineTo(pts.last.dx, pts.last.dy);

    // Fill
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(fill, Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.18), color.withOpacity(0)])
        .createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill);

    // Line
    canvas.drawPath(path, Paint()
      ..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);
  }

  @override
  bool shouldRepaint(_SparklinePainter o) => o.color != color;
}

class _ChartPainter extends CustomPainter {
  const _ChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Grid lines
    final grid = Paint()..color = const Color(0xFFF1F5F9)..strokeWidth = 0.8;
    for (int i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    // Data points: Mon–Sun trending upward
    final pts = [
      Offset(0,                   size.height * 0.667),
      Offset(size.width * 0.167, size.height * 0.60),
      Offset(size.width * 0.333, size.height * 0.40),
      Offset(size.width * 0.500, size.height * 0.333),
      Offset(size.width * 0.667, size.height * 0.467),
      Offset(size.width * 0.833, size.height * 0.333),
      Offset(size.width * 1.000, size.height * 0.133),
    ];
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final m = Offset((pts[i].dx + pts[i + 1].dx) / 2, (pts[i].dy + pts[i + 1].dy) / 2);
      path.quadraticBezierTo(pts[i].dx, pts[i].dy, m.dx, m.dy);
    }
    path.lineTo(pts.last.dx, pts.last.dy);

    // Fill
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(fill, Paint()
      ..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0x406366F1), Color(0x006366F1)])
        .createShader(Rect.fromLTWH(0, 0, 1000, 1000))
      ..style = PaintingStyle.fill);

    canvas.drawPath(path, Paint()
      ..color = const Color(0xFF6366F1)..style = PaintingStyle.stroke
      ..strokeWidth = 1.5..strokeCap = StrokeCap.round);

    // Peak dot
    canvas.drawCircle(pts.last, 4.5, Paint()..color = const Color(0xFF6366F1));
    canvas.drawCircle(pts.last, 4.5, Paint()
      ..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(_ChartPainter o) => false;
}
