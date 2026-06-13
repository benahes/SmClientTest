import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'main_shell.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard_screen.dart'; // for GlassCard
import 'channels_screen.dart';

const _ki  = Color(0xFF6366F1);
const _kid = Color(0xFF4F46E5);
const _kDk = Color(0xFF0F172A);
const _kMu = Color(0xFF94A3B8);
const _ke  = Color(0xFF10B981);
const _ka  = Color(0xFFF59E0B);
const _kr  = Color(0xFFEF4444);
const _kSb = Color(0xFF64748B);

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  bool _t1 = true;
  bool _t2 = true;
  bool _t3 = true;
  bool _t4 = false;
  bool _t5 = true;
  bool _c1 = true;
  bool _c2 = true;

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
                    Text('Configure your',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70, height: 1)),
                    Text('AI Brain 🧠',
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
                    child: const Icon(Icons.power_settings_new_rounded, size: 15, color: Colors.white),
                  ),
                  Positioned(top: 6, right: 6, child: Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      color: _ke, shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  )),
                ]),
              ]),
            ),
            
            // Body
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Active Channels Form
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('ACTIVE CHANNELS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ChannelsScreen()),
                          ),
                          child: const Text('See All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _ki)),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      GlassCard(
                        borderRadius: BorderRadius.circular(16),
                        padding: EdgeInsets.zero,
                        leftBorderWidth: 0,
                        child: Column(
                          children: [
                            _buildChannelItem(
                              iconWidget: const FaIcon(FontAwesomeIcons.whatsapp, size: 15, color: Color(0xFF25D366)),
                              iconBg: const Color(0xFFECFDF5),
                              title: 'Sales Bot',
                              subtitle: '+1 (555) 019-8372',
                              isActive: _c1,
                              onChanged: (v) => setState(() => _c1 = v),
                            ),
                            Container(height: 1, color: Colors.grey.withOpacity(0.08)),
                            _buildChannelItem(
                              iconWidget: const FaIcon(FontAwesomeIcons.telegram, size: 15, color: Color(0xFF229ED9)),
                              iconBg: const Color(0xFFEFF6FF),
                              title: 'Support Bot',
                              subtitle: '@MyStoreAgent',
                              isActive: _c2,
                              onChanged: (v) => setState(() => _c2 = v),
                            ),
                            Container(height: 1, color: Colors.grey.withOpacity(0.08)),
                            GestureDetector(
                              onTap: (){},
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_circle_outline_rounded, size: 14, color: _ki),
                                    SizedBox(width: 6),
                                    Text('Add New Channel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _ki)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 11),

                      // Base Instructions
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('BASE INSTRUCTIONS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
                        GestureDetector(
                          onTap: (){},
                          child: const Text('Use Template', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _ki)),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
                        ),
                        child: Column(
                          children: [
                            const TextField(
                              maxLines: 9,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _kDk),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                                hintText: 'You are a helpful sales assistant. Your goal is to be polite, answer queries about inventory, and secure the sale...',
                                hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(children: [
                                      const Icon(Icons.theater_comedy_outlined, size: 12, color: Color(0xFFC084FC)),
                                      const SizedBox(width: 6),
                                      const Expanded(child: Text('Professional', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kDk))),
                                      const Icon(Icons.keyboard_arrow_down, size: 12, color: _kMu),
                                    ]),
                                  ),
                                  Container(width: 1, height: 16, color: Colors.grey.withOpacity(0.2), margin: const EdgeInsets.symmetric(horizontal: 12)),
                                  Expanded(
                                    child: Row(children: [
                                      const Icon(Icons.language, size: 12, color: Color(0xFF818CF8)),
                                      const SizedBox(width: 6),
                                      const Expanded(child: Text('English (US)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kDk))),
                                      const Icon(Icons.keyboard_arrow_down, size: 12, color: _kMu),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Knowledge Base 
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('KNOWLEDGE BASE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
                        const Text('2 files active', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
                      ]),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        height: 76,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF)]),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFA5B4FC).withOpacity(0.6), width: 1.5),
                        ),
                        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.cloud_upload_rounded, size: 20, color: _ki),
                          SizedBox(height: 6),
                          Text('Upload PDFs, Docs, or Text', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kSb)),
                          Text('Train AI on your specific business rules', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
                        ]),
                      ),
                      const SizedBox(height: 12),

                      // AI Capabilities Toggles
                      const Text('AI CAPABILITIES', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.5)),
                      const SizedBox(height: 6),
                      GlassCard(
                        borderRadius: BorderRadius.circular(16),
                        padding: EdgeInsets.zero,
                        leftBorderWidth: 0,
                        child: Column(children: [
                          _buildToggleRow(Icons.reply_all, const Color(0xFF0EA5E9), 'Auto Reply', 'Respond to inquiries 24/7', _t1, (v) => setState(() => _t1 = v)),
                          Container(height: 1, color: const Color(0xFFF8FAFC)),
                          _buildToggleRow(Icons.done_all, _ke, 'AI Close Sales', 'Send payment links automatically', _t2, (v) => setState(() => _t2 = v)),
                          Container(height: 1, color: const Color(0xFFF8FAFC)),
                          _buildToggleRow(Icons.trending_up, _ka, 'AI Upsell', 'Pitch add-ons during checkout', _t3, (v) => setState(() => _t3 = v)),
                          Container(height: 1, color: const Color(0xFFF8FAFC)),
                          _buildToggleRow(Icons.update, _ki, 'AI Follow-up', 'Chase abandoned conversations', _t4, (v) => setState(() => _t4 = v)),
                          Container(height: 1, color: const Color(0xFFF8FAFC)),
                          _buildToggleRow(Icons.handshake_outlined, const Color(0xFFA855F7), 'AI Haggling', 'Negotiate prices based on limits', _t5, (v) => setState(() => _t5 = v)),
                        ]),
                      ),
                      const SizedBox(height: 24),

                      // Normal scrollable Save Button
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [_ki, Color(0xFF9333EA)]), // indigo to purple
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: _ki.withOpacity(0.35), blurRadius: 15, offset: const Offset(0, 6))],
                        ),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.done_all, size: 14, color: Colors.white),
                          SizedBox(width: 8),
                          Text('SAVE BRAIN CONFIG', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                        ]),
                      ),
                      const SizedBox(height: 32),
                    ]),
                  ),
                ],
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _buildToggleRow(IconData icon, Color iconColor, String title, String sub, bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(width: 28, height: 28, decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 12, color: iconColor)),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kDk)),
              const SizedBox(height: 2),
              Text(sub, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _kMu)),
            ]),
          ]),
          // Custom switch
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32, height: 18,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: value ? const LinearGradient(colors: [_ki, Color(0xFFA855F7)]) : const LinearGradient(colors: [Color(0xFFE2E8F0), Color(0xFFE2E8F0)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)])),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildChannelItem({
    required Widget iconWidget,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool isActive,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!isActive),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Center(child: iconWidget),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kDk, letterSpacing: -0.2)),
              const SizedBox(height: 1),
              Text(subtitle, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _kMu)),
            ]),
          ]),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32, height: 18,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: isActive ? const LinearGradient(colors: [_ki, Color(0xFFA855F7)]) : const LinearGradient(colors: [Color(0xFFE2E8F0), Color(0xFFE2E8F0)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)])),
            ),
          ),
        ]),
      ),
    );
  }
}
