import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'main_shell.dart';
import 'dashboard_screen.dart'; // GlassCard
import 'add_booking_modal.dart';

// ── Tokens ────────────────────────────────────────────────────────────────────
const _ki  = Color(0xFF6366F1);
const _kid = Color(0xFF4F46E5);
const _kDk = Color(0xFF0F172A);
const _kMu = Color(0xFF94A3B8);
const _ke  = Color(0xFF10B981);
const _ka  = Color(0xFFF59E0B);
const _kSb = Color(0xFF64748B);
const _kBg = Color(0xFFEDF1F8);

// ── Booking status ────────────────────────────────────────────────────────────
enum _BookStatus { confirmed, pending, inProgress }

class _Booking {
  final String time;
  final String period; // AM / PM
  final String category;
  final String title;
  final String clientName;
  final String clientInitials;
  final String? clientAvatar;
  final String detail;
  final IconData detailIcon;
  final _BookStatus status;
  final bool aiBooked;

  const _Booking({
    required this.time,
    required this.period,
    required this.category,
    required this.title,
    required this.clientName,
    required this.clientInitials,
    this.clientAvatar,
    required this.detail,
    required this.detailIcon,
    required this.status,
    this.aiBooked = false,
  });
}

// ── Calendar dot data: day → list of colours ──────────────────────────────────
const _dotDays = <int, List<Color>>{
  3:  [Color(0xFFF59E0B)],
  4:  [Color(0xFF6366F1)],
  9:  [Color(0xFF6366F1)],
  10: [Color(0xFFF59E0B)],
  17: [Color(0xFF6366F1)],
  19: [Color(0xFFF59E0B), Color(0xFF6366F1)],
};

// ── Bookings for selected day ─────────────────────────────────────────────────
const _bookings = <_Booking>[
  _Booking(
    time: '09:00', period: 'AM',
    category: 'Service',
    title: 'Deep Home Cleaning',
    clientName: 'Sarah Jenkins',
    clientInitials: 'SJ',
    clientAvatar: 'https://i.pravatar.cc/100?img=47',
    detail: '2 Hrs',
    detailIcon: Icons.schedule_rounded,
    status: _BookStatus.confirmed,
  ),
  _Booking(
    time: '11:30', period: 'AM',
    category: 'Consultation',
    title: 'UI/UX Audit',
    clientName: 'Marcus Chen',
    clientInitials: 'MC',
    detail: 'Google Meet',
    detailIcon: Icons.videocam_rounded,
    status: _BookStatus.pending,
    aiBooked: true,
  ),
  _Booking(
    time: '02:15', period: 'PM',
    category: 'Session',
    title: '1-on-1 PT Session',
    clientName: 'David Miller',
    clientInitials: 'DM',
    clientAvatar: 'https://i.pravatar.cc/100?img=12',
    detail: 'Studio B',
    detailIcon: Icons.location_on_rounded,
    status: _BookStatus.inProgress,
  ),
];

// ═══════════════════════════════════════════════════════════════════════════════
//  SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  bool _monthlyView = true;
  int _selectedDay = 16;

  // Calendar state – May 2026 (current month)
  int _calYear  = 2026;
  int _calMonth = 5; // 1-indexed

  static const _monthNames = [
    '', 'January','February','March','April','May','June',
    'July','August','September','October','November','December',
  ];
  static const _dayLabels = ['Su','Mo','Tu','We','Th','Fr','Sa'];

  int get _daysInMonth => DateTime(_calYear, _calMonth + 1, 0).day;
  int get _firstWeekday => DateTime(_calYear, _calMonth, 1).weekday % 7; // 0=Sun

  void _prevMonth() => setState(() {
    _calMonth--;
    if (_calMonth < 1) { _calMonth = 12; _calYear--; }
    _selectedDay = 1;
  });

  void _nextMonth() => setState(() {
    _calMonth++;
    if (_calMonth > 12) { _calMonth = 1; _calYear++; }
    _selectedDay = 1;
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: _kBg,
        body: Stack(children: [

          // ── Mesh Orbs ──────────────────────────────────────────────────────
          Positioned(
            top: -100, left: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(width: 350, height: 350,
                decoration: const BoxDecoration(shape: BoxShape.circle,
                  color: Color.fromRGBO(99, 102, 241, 0.20))),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.30, right: -150,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(width: 450, height: 450,
                decoration: const BoxDecoration(shape: BoxShape.circle,
                  color: Color.fromRGBO(16, 185, 129, 0.14))),
            ),
          ),
          Positioned(
            bottom: -50, left: MediaQuery.of(context).size.width * 0.1,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(width: 400, height: 400,
                decoration: const BoxDecoration(shape: BoxShape.circle,
                  color: Color.fromRGBO(99, 102, 241, 0.16))),
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
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // Avatar + title
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
                    Text('Manage your',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70, height: 1)),
                    Text('Bookings 📅',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.2)),
                  ]),
                ]),
                // Search button
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: const Icon(Icons.search_rounded, size: 15, color: Colors.white),
                ),
              ]),
            ),

            // ── View Toggle ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
                ),
                child: Row(children: [
                  _ViewTab(label: 'Weekly View',  active: !_monthlyView, onTap: () => setState(() => _monthlyView = false)),
                  _ViewTab(label: 'Monthly View', active: _monthlyView,  onTap: () => setState(() => _monthlyView = true)),
                ]),
              ),
            ),

            // ── Scrollable body ───────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  // ── Calendar card ─────────────────────────────────────────
                  _CalendarCard(
                    year: _calYear,
                    month: _calMonth,
                    monthName: _monthNames[_calMonth],
                    daysInMonth: _daysInMonth,
                    firstWeekday: _firstWeekday,
                    selectedDay: _selectedDay,
                    onPrev: _prevMonth,
                    onNext: _nextMonth,
                    onDayTap: (d) => setState(() => _selectedDay = d),
                  ),
                  const SizedBox(height: 14),

                  // ── Schedule header ───────────────────────────────────────
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      '${_monthNames[_calMonth].substring(0, 3)} $_selectedDay Schedule',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.4),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFC7D2FE)),
                      ),
                      child: Text(
                        '${_bookings.length} Bookings',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _ki),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),

                  // ── Timeline ─────────────────────────────────────────────
                  ..._bookings.asMap().entries.map((e) {
                    final isLast = e.key == _bookings.length - 1;
                    return _TimelineItem(booking: e.value, isLast: isLast);
                  }),

                ]),
              ),
            ),
          ]),

          // ── FAB ───────────────────────────────────────────────────────────
          Positioned(
            bottom: 108, right: 16,
            child: GestureDetector(
              onTap: () => showAddBookingModal(context),
              child: Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_ki, _kid], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: _ki.withOpacity(0.42), blurRadius: 18, offset: const Offset(0, 6))],
                ),
                child: const Icon(Icons.calendar_month_rounded, size: 20, color: Colors.white),
              ),
            ),
          ),

        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  VIEW TOGGLE TAB
// ═══════════════════════════════════════════════════════════════════════════════

class _ViewTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ViewTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))] : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: active ? _ki : _kMu,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  CALENDAR CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _CalendarCard extends StatelessWidget {
  final int year, month, daysInMonth, firstWeekday, selectedDay;
  final String monthName;
  final VoidCallback onPrev, onNext;
  final ValueChanged<int> onDayTap;

  const _CalendarCard({
    required this.year,
    required this.month,
    required this.monthName,
    required this.daysInMonth,
    required this.firstWeekday,
    required this.selectedDay,
    required this.onPrev,
    required this.onNext,
    required this.onDayTap,
  });

  // Prev month overflow days
  int get _prevMonthDays => DateTime(year, month, 0).day;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(12),
      leftBorderWidth: 0,
      child: Column(children: [

        // ── Month header ────────────────────────────────────────────────────
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            '$monthName $year',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: _kDk),
          ),
          Row(children: [
            _CalNavBtn(icon: Icons.chevron_left_rounded, onTap: onPrev),
            const SizedBox(width: 6),
            _CalNavBtn(icon: Icons.chevron_right_rounded, onTap: onNext),
          ]),
        ]),
        const SizedBox(height: 8),

        // ── Day labels ──────────────────────────────────────────────────────
        Row(
          children: ['Su','Mo','Tu','We','Th','Fr','Sa'].map((d) => Expanded(
            child: Text(d, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 0.5)),
          )).toList(),
        ),
        const SizedBox(height: 6),

        // ── Grid ────────────────────────────────────────────────────────────
        _buildGrid(),

      ]),
    );
  }

  Widget _buildGrid() {
    final cells = <Widget>[];
    final today = DateTime.now();
    final isCurrentMonth = today.year == year && today.month == month;

    // Prev month overflow
    for (int i = firstWeekday - 1; i >= 0; i--) {
      cells.add(_DayCell(day: _prevMonthDays - i, faded: true));
    }

    // Current month days
    for (int d = 1; d <= daysInMonth; d++) {
      final dots = _dotDays[d] ?? [];
      final isSelected = d == selectedDay;
      final isToday = isCurrentMonth && d == today.day;
      cells.add(_DayCell(
        day: d,
        dots: dots,
        selected: isSelected,
        isToday: isToday && !isSelected,
        onTap: () => onDayTap(d),
      ));
    }

    // Next month overflow to complete last row
    final remainder = cells.length % 7;
    if (remainder != 0) {
      for (int i = 1; i <= 7 - remainder; i++) {
        cells.add(_DayCell(day: i, faded: true));
      }
    }

    // Build rows
    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      final rowCells = cells.sublist(i, (i + 7).clamp(0, cells.length));
      rows.add(Row(children: rowCells.map((c) => Expanded(child: c)).toList()));
      if (i + 7 < cells.length) rows.add(const SizedBox(height: 2));
    }
    return Column(children: rows);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  DAY CELL
// ═══════════════════════════════════════════════════════════════════════════════

class _DayCell extends StatelessWidget {
  final int day;
  final bool faded;
  final bool selected;
  final bool isToday;
  final List<Color> dots;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    this.faded = false,
    this.selected = false,
    this.isToday = false,
    this.dots = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: faded ? null : onTap,
      child: SizedBox(
        height: 30,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: selected
                  ? const LinearGradient(colors: [_ki, _kid], begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : null,
              color: isToday ? const Color(0xFFEEF2FF) : null,
              boxShadow: selected
                  ? [BoxShadow(color: _ki.withOpacity(0.38), blurRadius: 8, offset: const Offset(0, 3))]
                  : null,
            ),
            child: Stack(alignment: Alignment.center, children: [
              Text(
                '$day',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: faded
                      ? const Color(0xFFCBD5E1)
                      : selected
                          ? Colors.white
                          : isToday
                              ? _ki
                              : _kDk,
                ),
              ),
              // Notification dot on selected
              if (selected && dots.isNotEmpty)
                Positioned(
                  top: 1, right: 2,
                  child: Container(
                    width: 5, height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF43F5E),
                      shape: BoxShape.circle,
                      border: Border.all(color: _ki, width: 1),
                    ),
                  ),
                ),
            ]),
          ),
          // Event dots below number
          if (!selected && dots.isNotEmpty) ...[
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dots.map((c) => Container(
                width: 4, height: 4, margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(color: c, shape: BoxShape.circle),
              )).toList(),
            ),
          ],
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  CALENDAR NAV BUTTON
// ═══════════════════════════════════════════════════════════════════════════════

class _CalNavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CalNavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24, height: 24,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Icon(icon, size: 14, color: _kSb),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TIMELINE ITEM
// ═══════════════════════════════════════════════════════════════════════════════

class _TimelineItem extends StatelessWidget {
  final _Booking booking;
  final bool isLast;
  const _TimelineItem({required this.booking, required this.isLast});

  Color get _dotColor {
    switch (booking.status) {
      case _BookStatus.confirmed:   return _ke;
      case _BookStatus.pending:     return _ka;
      case _BookStatus.inProgress:  return _ki;
    }
  }

  (Color, Color, Color, String) get _badge {
    switch (booking.status) {
      case _BookStatus.confirmed:
        return (const Color(0xFFECFDF5), const Color(0xFF059669), const Color(0xFFD1FAE5), 'Confirmed');
      case _BookStatus.pending:
        return (const Color(0xFFFFFBEB), const Color(0xFFD97706), const Color(0xFFFDE68A), 'Pending');
      case _BookStatus.inProgress:
        return (const Color(0xFFEEF2FF), _ki, const Color(0xFFC7D2FE), 'In Progress');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bgB, textB, borderB, labelB) = _badge;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Time + timeline spine ────────────────────────────────────────
          SizedBox(
            width: 44,
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(booking.time,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: _kDk, height: 1)),
              Text(booking.period,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu)),
            ]),
          ),

          // ── Dot + spine ──────────────────────────────────────────────────
          SizedBox(
            width: 22,
            child: Column(children: [
              const SizedBox(height: 3),
              Container(
                width: 9, height: 9,
                decoration: BoxDecoration(
                  color: _dotColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: _kBg, width: 1.5),
                  boxShadow: [BoxShadow(color: _dotColor.withOpacity(0.4), blurRadius: 4)],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.only(top: 3),
                  ),
                ),
            ]),
          ),

          // ── Booking card ─────────────────────────────────────────────────
          Expanded(
            child: GlassCard(
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.all(10),
              leftBorderWidth: 0,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                // Top row
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(booking.category.toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _kMu, letterSpacing: 1.2)),
                    const SizedBox(height: 2),
                    Row(children: [
                      Text(booking.title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: _kDk, letterSpacing: -0.2)),
                      if (booking.aiBooked) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.auto_awesome_rounded, size: 9, color: Color(0xFFA855F7)),
                      ],
                    ]),
                  ]),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: bgB,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: borderB),
                    ),
                    child: Text(labelB,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: textB, letterSpacing: 0.5)),
                  ),
                ]),
                const SizedBox(height: 8),

                // Divider
                Container(height: 1, color: const Color(0x0A000000)),
                const SizedBox(height: 8),

                // Bottom row: client + detail
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    _ClientAvatar(avatar: booking.clientAvatar, initials: booking.clientInitials),
                    const SizedBox(width: 6),
                    Text(booking.clientName,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _kSb)),
                  ]),
                  Row(children: [
                    Icon(booking.detailIcon, size: 9, color: _ki),
                    const SizedBox(width: 4),
                    Text(booking.detail,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _ki)),
                  ]),
                ]),

              ]),
            ),
          ),

        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  CLIENT AVATAR
// ═══════════════════════════════════════════════════════════════════════════════

class _ClientAvatar extends StatelessWidget {
  final String? avatar;
  final String initials;
  const _ClientAvatar({this.avatar, required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEEF2FF),
        border: Border.all(color: const Color(0xFFC7D2FE), width: 1),
      ),
      child: ClipOval(
        child: avatar != null
            ? Image.network(avatar!, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _InitialsWidget(initials))
            : _InitialsWidget(initials),
      ),
    );
  }
}

class _InitialsWidget extends StatelessWidget {
  final String initials;
  const _InitialsWidget(this.initials);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEEF2FF),
      child: Center(
        child: Text(initials,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: _ki)),
      ),
    );
  }
}
