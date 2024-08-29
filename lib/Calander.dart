import 'package:calendar/NewEvent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar/EventsData.dart';

class events_with_calander extends StatefulWidget {
  @override
  _events_with_calanderState createState() => _events_with_calanderState();
}

class _events_with_calanderState extends State<events_with_calander> {
  late final ValueNotifier<List<Map>> _selectedEvents;

  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  // all events data
  List<Map> _getEventsForDay(DateTime day) {
    print(data);
    return data[day] ?? [];
  }

  // select day
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar<Map>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: true,
            ),
            onDaySelected: _onDaySelected,
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
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Map>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                          onTap: () =>
                              print('${value[index]["title"]} \n ${index}'),
                          title: Container(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Title : ${value[index]["title"]}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                    'Time : ${DateFormat.jm().format(DateTime(2000, 1, 1, value[index]["start"].hour, value[index]["start"].minute))} - ${DateFormat.jm().format(DateTime(2000, 1, 1, value[index]["end"].hour, value[index]["end"].minute))}'),
                                Text('Note : ${value[index]["note"]}'),
                              ],
                            ),
                          )),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                alignment: Alignment.topRight,
                icon: const Icon(
                  Icons.add_circle_rounded,
                  size: 70,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => new_event(date: _selectedDay!)));
                  
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
