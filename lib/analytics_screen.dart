import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'main_shell.dart';
import 'dashboard_screen.dart'; // for GlassCard

const _ki  = Color(0xFF6366F1);
const _kid = Color(0xFF4F46E5);
const _kDk = Color(0xFF0F172A);
const _kMu = Color(0xFF94A3B8);
const _ke  = Color(0xFF10B981);
const _ka  = Color(0xFFF59E0B);
const _kr  = Color(0xFFEF4444);

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent, 
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
          
          Column(children: [
            // Dashboard-style Header
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
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                    Text('Here is your',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70, height: 1)),
                    Text('Analytics 📈',
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
              ]),
            ),
            
            // Analytics Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildGrossVolume(),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _buildConversionCard()),
                    const SizedBox(width: 12),
                    Expanded(child: _buildCustomerGrowth()),
                  ]),
                  const SizedBox(height: 12),
                  _buildAiPerformance(),
                  const SizedBox(height: 12),
                  _buildPeakActivity(),
                  const SizedBox(height: 12),
                  _buildTopProducts(),
                ]),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  // ── 1. Gross Volume Card ──────────────────────────────────────────────────
  Widget _buildGrossVolume() {
    return GlassCard(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(12),
      leftBorderWidth: 0,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('GROSS VOLUME', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
              const Text('\$24,500.00', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _kDk, letterSpacing: -0.5)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFA7F3D0).withOpacity(0.5)),
                ),
                child: const Row(children: [
                  Icon(Icons.trending_up, size: 8, color: _ke),
                  SizedBox(width: 2),
                  Text('+14.5%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _ke)),
                ]),
              ),
            ]),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: const Text('7 Days', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
          ),
        ]),
        const SizedBox(height: 16),
        // Bar Chart (Custom)
        SizedBox(height: 64, child: Stack(children: [
          // Background dashed lines
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(height: 1, color: Colors.grey.withOpacity(0.2)),
            Container(height: 1, color: Colors.grey.withOpacity(0.2)),
            Container(height: 1, color: Colors.transparent), // base
          ]),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildVolBar(0.4, false, 'Mon'),
              _buildVolBar(0.65, false, 'Tue'),
              _buildVolBar(0.45, false, 'Wed'),
              _buildVolBar(0.8, false, 'Thu'),
              _buildVolBar(0.55, false, 'Fri'),
              _buildVolBar(0.95, true, 'Sat'),
              _buildVolBar(0.3, false, 'Sun'),
            ],
          ),
        ])),
      ]),
    );
  }

  Widget _buildVolBar(double heightFactor, bool active, String label) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Container(
        width: 32,
        height: 48 * heightFactor,
        decoration: BoxDecoration(
          color: active ? _ki : const Color(0xFFEEF2FF),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
        ),
      ),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w800 : FontWeight.w700, color: active ? _ki : _kMu)),
    ]);
  }

  // ── 2a. Conversion Rate ───────────────────────────────────────────────────
  Widget _buildConversionCard() {
    return GlassCard(
      borderRadius: BorderRadius.circular(16),
      leftBorderWidth: 0,
      padding: EdgeInsets.zero,
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(width: 24, height: 24, decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.filter_alt_outlined, size: 12, color: _ki)),
              const Row(children: [
                Icon(Icons.arrow_drop_up, size: 12, color: _ke),
                Text('1.2%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _ke)),
              ]),
            ]),
            const SizedBox(height: 4),
            const Text('4.8%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _kDk)),
            const Text('Conversion Rate', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kMu)),
          ]),
        ),
        Positioned(bottom: 0, left: 0, right: 0, child: SizedBox(height: 28,
          child: CustomPaint(painter: _MiniLinePainter(const [0.8, 0.6, 0.7, 0.4, 0.5, 0.2], _ki)))),
      ]),
    );
  }

  // ── 2b. Customer Growth ───────────────────────────────────────────────────
  Widget _buildCustomerGrowth() {
    return GlassCard(
      borderRadius: BorderRadius.circular(16),
      leftBorderWidth: 0,
      padding: EdgeInsets.zero,
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(width: 24, height: 24, decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.people_outline, size: 12, color: _ke)),
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: _ke, shape: BoxShape.circle)),
            ]),
            const SizedBox(height: 4),
            const Text('+124', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _kDk)),
            const Text('New Customers', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kMu)),
          ]),
        ),
        Positioned(bottom: 0, left: 0, right: 0, child: SizedBox(height: 28,
          child: CustomPaint(painter: _MiniLinePainter(const [0.9, 0.7, 0.8, 0.4, 0.5, 0.1], _ke)))),
      ]),
    );
  }

  // ── 3. AI Performance ─────────────────────────────────────────────────────
  Widget _buildAiPerformance() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('AI AGENT PERFORMANCE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
      const SizedBox(height: 6),
      GlassCard(
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(12),
        leftBorderWidth: 2,
        leftBorderColor: _ka,
        child: Column(children: [
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Icon(Icons.smart_toy_outlined, size: 14, color: _ka),
              SizedBox(width: 6),
              Text('Autopilot Resolution', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kDk)),
            ]),
            Text('84%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kDk)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(
            value: 0.84, minHeight: 6, backgroundColor: Colors.grey.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation(_ka)),
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('1,204', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kDk)),
              Text('CHATS HANDLED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kMu)),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Text('\$4,200', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _ke)),
              const Text('AI REVENUE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kMu)),
            ]),
          ]),
        ]),
      ),
    ]);
  }

  // ── 4. Peak Activity Heatmap ──────────────────────────────────────────────
  Widget _buildPeakActivity() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('PEAK ACTIVITY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey.withOpacity(0.2))),
          child: const Row(children: [
            Icon(Icons.access_time, size: 9, color: _kMu), SizedBox(width: 4),
            Text('Local Time', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
          ]),
        ),
      ]),
      const SizedBox(height: 6),
      GlassCard(
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(12),
        leftBorderWidth: 0,
        child: SizedBox(height: 54, child: Stack(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _buildHeatBar(0.2, const Color(0xFFF1F5F9)),
            _buildHeatBar(0.35, const Color(0xFFE2E8F0)),
            _buildHeatBar(0.6, const Color(0xFFC7D2FE)),
            _buildHeatBar(0.85, const Color(0xFF818CF8)),
            _buildHeatBar(1.0, _ki),
            _buildHeatBar(0.7, const Color(0xFFA5B4FC)),
            _buildHeatBar(0.4, const Color(0xFFE2E8F0)),
            _buildHeatBar(0.15, const Color(0xFFF1F5F9)),
          ]),
          Align(alignment: Alignment.bottomCenter, child: Container(height: 1, color: Colors.grey.withOpacity(0.1))),
        ])),
      ),
    ]);
  }

  Widget _buildHeatBar(double factor, Color c) {
    return Container(
      width: 32, height: 48 * factor,
      decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
    );
  }

  // ── 5. Top Products ───────────────────────────────────────────────────────
  Widget _buildTopProducts() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('TOP PRODUCTS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
      const SizedBox(height: 6),
      GlassCard(
        borderRadius: BorderRadius.circular(16),
        padding: const EdgeInsets.all(6),
        leftBorderWidth: 0,
        child: Column(children: [
          _buildProdRow(Icons.checkroom, 'Nike Air Max 270', 'Footwear • 142 sold', '\$18,460'),
          Container(height: 1, color: Colors.grey.withOpacity(0.1), margin: const EdgeInsets.symmetric(vertical: 2)),
          _buildProdRow(Icons.dry_cleaning, 'Essential Hoodie', 'Apparel • 84 sold', '\$4,200'),
          Container(height: 1, color: Colors.grey.withOpacity(0.1), margin: const EdgeInsets.symmetric(vertical: 2)),
          _buildProdRow(Icons.visibility, 'Polarized Shades', 'Accessories • 56 sold', '\$1,840'),
        ]),
      ),
    ]);
  }

  Widget _buildProdRow(IconData icon, String title, String sub, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.1))),
            child: Icon(icon, size: 14, color: _kMu)),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kDk)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _kMu)),
          ]),
        ]),
        Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: _kDk)),
      ]),
    );
  }
}

// ── Mini SVG Chart Painter ──────────────────────────────────────────────────
class _MiniLinePainter extends CustomPainter {
  final List<double> values;
  final Color baseColor;

  _MiniLinePainter(this.values, this.baseColor);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final step = size.width / (values.length - 1);
    
    path.moveTo(0, size.height * values[0]);
    for (int i = 1; i < values.length; i++) {
      final x = i * step;
      final y = size.height * values[i];
      final prevX = (i - 1) * step;
      final prevY = size.height * values[i-1];
      
      final cpX = prevX + (x - prevX) / 2;
      path.cubicTo(cpX, prevY, cpX, y, x, y);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [baseColor.withOpacity(0.2), baseColor.withOpacity(0.0)])
        .createShader(Offset.zero & size));

    canvas.drawPath(path, Paint()
      ..color = baseColor..strokeWidth = 2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
