import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/date_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime kFirstDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime _focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    DateTime kLastDay =
        DateTime(kFirstDay.year, kFirstDay.month + 3, kFirstDay.day);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                            )),
                        Expanded(child: SizedBox()),
                        Text(
                          (_rangeStart == null || _rangeEnd == null)
                              ? '---'
                              : '${DateFormat('dd MMMM yyyy').format(_rangeStart!)}-${DateFormat('dd MMMM yyyy').format(_rangeEnd!)}',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TableCalendar(
                      calendarStyle: CalendarStyle(
                          rangeHighlightColor: Colors.grey.shade300,
                          isTodayHighlighted: false,
                          todayDecoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          rangeEndDecoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          rangeStartDecoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          markerDecoration: BoxDecoration(color: Colors.black)),
                      headerStyle: HeaderStyle(formatButtonVisible: false),
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      calendarFormat: _calendarFormat,
                      rangeSelectionMode: _rangeSelectionMode,
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            _rangeStart = null; // Important to clean those
                            _rangeEnd = null;
                            _rangeSelectionMode = RangeSelectionMode.toggledOff;
                          });
                        }
                      },
                      onRangeSelected: (start, end, focusedDay) {
                        setState(() {
                          _selectedDay = null;
                          _focusedDay = focusedDay;
                          _rangeStart = start;
                          _rangeEnd = end;
                          _rangeSelectionMode = RangeSelectionMode.toggledOn;
                        });
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: (_rangeStart == null || _rangeEnd == null)
                        ? null
                        : () {
                            Provider.of<DateProvider>(context, listen: false)
                                .updateRange(_rangeStart!, _rangeEnd!);
                            Navigator.pop(context);
                          },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 15, right: 15, top: 2, bottom: 10),
                      width: 100,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: (_rangeStart == null || _rangeEnd == null)
                              ? Colors.grey
                              : Colors.black,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'Save',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont('Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
