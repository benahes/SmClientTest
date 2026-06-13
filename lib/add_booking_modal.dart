import 'package:flutter/material.dart';
import 'dart:ui';

// ── Color tokens ────────────────────────────────────────────────────────────
const _ki  = Color(0xFF6366F1);
const _kid = Color(0xFF4F46E5);
const _kDk = Color(0xFF0F172A);
const _kMu = Color(0xFF94A3B8);
const _kSb = Color(0xFF64748B);

// ═══════════════════════════════════════════════════════════════════════════════
//  ADD BOOKING MODAL
// ═══════════════════════════════════════════════════════════════════════════════

Future<void> showAddBookingModal(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (BuildContext context) => const _AddBookingModalContent(),
  );
}

class _AddBookingModalContent extends StatefulWidget {
  const _AddBookingModalContent();

  @override
  State<_AddBookingModalContent> createState() => _AddBookingModalContentState();
}

class _AddBookingModalContentState extends State<_AddBookingModalContent> {
  bool _sendWhatsApp = true;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      top: false,
      child: Container(
        height: screenHeight * 0.72 + bottomInset + 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with drag handle
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(top: 10, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Add Booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _kDk)),
                      GestureDetector(onTap: () => Navigator.pop(context), child: Container(width:28, height:28, decoration: BoxDecoration(color: const Color(0xFFF8FAFC), shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)), child: Icon(Icons.close_rounded, size:16, color: Colors.grey.shade600))),
                    ],
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildFormGroup(label: 'Select Customer', suffixLabel: '+ New', child: _buildSelect(icon: Icons.person_outline_rounded, items: const ['Search or select client...','Sarah Jenkins','Marcus Chen','David Miller'])),
                  const SizedBox(height:8),
                  _buildFormGroup(label: 'Service Type', child: _buildSelect(icon: Icons.work_outline_rounded, items: const ['Select a service to book...','Deep Home Cleaning (2 Hrs)','UI/UX Audit (1 Hr)','1-on-1 PT Session (45 Mins)'])),
                  const SizedBox(height:8),
                  Row(children: [Expanded(child: _buildFormGroup(label: 'Date', child: _buildDateInput())), const SizedBox(width:10), Expanded(child: _buildFormGroup(label: 'Time', child: _buildTimeInput()))]),
                  const SizedBox(height:8),
                  _buildFormGroup(label: 'Assigned To', child: _buildSelect(icon: Icons.person_add_outlined, items: const ['Assign to Me','Agent: John Doe','AI Booking Agent'])),
                  const SizedBox(height:8),
                  _buildFormGroup(label: 'Internal Notes (Optional)', child: TextField(maxLines:2, decoration: InputDecoration(hintText: 'Add any special requirements or notes...', hintStyle: TextStyle(fontSize:14, color: Colors.grey.shade400), filled:true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200, width:1)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200, width:1)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _ki, width:1.5)), contentPadding: const EdgeInsets.all(8)))),
                  const SizedBox(height:8),
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF0F4FF), border: Border.all(color: const Color(0xFFDDD6FE), width:1), borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Container(width:32, height:32, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFDDD6FE), width:1)), child: const Icon(Icons.check, size:14, color: _ki)), const SizedBox(width:10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Send Confirmation', style: TextStyle(fontSize:14, fontWeight: FontWeight.w700, color: _kDk)), const SizedBox(height:4), Text('Automated WhatsApp message', style: TextStyle(fontSize:12, fontWeight: FontWeight.w600, color: Colors.grey.shade500))])]), Switch(value: _sendWhatsApp, onChanged: (v) => setState(() => _sendWhatsApp = v), activeColor: _ki, inactiveThumbColor: Colors.white, inactiveTrackColor: Colors.grey.shade300)])),
                ]),
              ),
            ),

            // Sticky Button
            Container(padding: EdgeInsets.fromLTRB(12,8,12,12 + bottomInset), decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200, width:1)), color: Colors.white), child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(height:44, decoration: BoxDecoration(gradient: const LinearGradient(colors: [_ki, _kid], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: _ki.withOpacity(0.35), blurRadius:15, offset: const Offset(0,6))]), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Text('Confirm Booking', style: TextStyle(fontSize:14, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing:0.5)), SizedBox(width:6), Icon(Icons.event_available_outlined, size:18, color: Colors.white)])))),
          ],
        ),
      ),
    );
  }

  Widget _buildFormGroup({
    required String label,
    String? suffixLabel,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: _kMu,
                letterSpacing: 1.2,
              ),
            ),
            if (suffixLabel != null)
              GestureDetector(
                onTap: () {
                  // Handle new customer
                },
                child: Text(
                  suffixLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _ki,
                    letterSpacing: 0.5,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget _buildSelect({
    required IconData icon,
    required List<String> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF8FAFC),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: Icon(icon, size: 18, color: _kMu),
            ),
          ),
          DropdownButton<String>(
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {},
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_drop_down, size: 18, color: _kMu),
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _kDk,
            ),
            padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
            hint: Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 0, 8),
              child: Text(
                items.first,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInput() {
    return GestureDetector(
      onTap: () async {
        await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
      },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF8FAFC),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(Icons.calendar_today_outlined, size: 18, color: _kMu),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Select date',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInput() {
    return GestureDetector(
      onTap: () async {
        await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
      },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF8FAFC),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(Icons.access_time_outlined, size: 18, color: _kMu),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Select time',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
