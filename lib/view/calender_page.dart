import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:irc_stew/model/event.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:irc_stew/data/calender_database.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _today = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime _showingDate = DateTime.now();
  String eventTypeValue = "to-do list"; // Default value for radio buttons
  Map<DateTime, List<Event>> events = {};
  final TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;
  final _dataBox = Hive.box('dataBox');
  DataBase db = DataBase();

  @override
  void initState() {
    super.initState();
    if (_dataBox.get("eventList") == null) {
      db.createInitialData();
      events.addAll({_selectedDay: db.eventList});
    }
    events = LinkedHashMap(
      equals: isSameDayWithoutTime,
      hashCode: getHashCode,
    )..addAll(events);

    _showingDate = _today;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text(
          "Calendar",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: "zh_TW",
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _today,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: _getEventsForDay,
            onDaySelected: _onDaySelected,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 3,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _showingDate.toString().split(" ")[0],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              scrollable: true,
                              title: const Text(
                                "新增項目",
                                style: TextStyle(fontSize: 20),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextField(
                                      controller: _eventController,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: "note",
                                        groupValue: eventTypeValue,
                                        onChanged: (value) {
                                          setState(() {
                                            eventTypeValue = value!;
                                          });
                                        },
                                      ),
                                      const Text(
                                        "記事",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Radio<String>(
                                        value: "to-do list",
                                        groupValue: eventTypeValue,
                                        onChanged: (value) {
                                          setState(() {
                                            eventTypeValue = value!;
                                          });
                                        },
                                      ),
                                      const Text(
                                        "待辦清單",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    final newEvent = Event(_eventController.text, eventTypeValue);
                                    final selectedEvents = events[_selectedDay] ?? [];
                                    selectedEvents.add(newEvent);
                                    events[_selectedDay] = selectedEvents;
                                    _eventController.clear();
                                    _selectedEvents.value = _getEventsForDay(_selectedDay);
                                    print(events);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("確定", style: TextStyle(fontSize: 20)),
                                )
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Wrap(
                            children: [
                              _itemShowing(events[_selectedDay]?[index].mode),
                            ],
                          ),
                          title: Text(
                            value[index].title,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _today = focusedDay;
      _showingDate = selectedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }
}

Widget _itemShowing(String? option) {
  switch (option) {
    case 'to-do list':
      return const Icon(Icons.check_box, size: 24);
    case 'note':
      return const Icon(Icons.circle, size: 24);
    default:
      return Container();
  }
}
