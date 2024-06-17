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
  List<Event> dayEvent = [];
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
      dayEvent = db.eventList;
      events.addAll({_selectedDay: dayEvent});
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
                                    setState(() {});
                                    dayEvent.add(Event(_eventController.text, eventTypeValue));
                                    _selectedEvents.value = _getEventsForDay(_selectedDay);
                                    events.addAll({_selectedDay: dayEvent});
                                    _selectedEvents.value = _getEventsForDay(_selectedDay);
                                    _onDaySelected;
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
                      child: Container
                      (
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile
                        (
                          leading: Wrap
                          (
                            children:
                            [
                              _itemShowing(events[_selectedDay]?[index].mode),
                            ],
                          ),
                          onTap: () => editEvent(context, index),
                          title: Text
                          (
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
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _today = focusedDay;
        _showingDate = selectedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
        dayEvent = [];
        print(events);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void deleteEvent(int index) {
    setState(() {});
    Event? event = events[_selectedDay]?[index];
    events[_selectedDay]?.remove(event);
    _selectedEvents.value = _getEventsForDay(_selectedDay);
  }

  void editEvent(BuildContext context, int index) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("編輯選項"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _eventController,
              decoration: const InputDecoration(
                hintText: "Enter text",
                hintStyle: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    deleteEvent(index);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete, size: 40),
                ),
                TextButton(
                  onPressed: () {
                    String newTitle = _eventController.text;
                    setState(() {
                      events[_selectedDay]?[index].title = newTitle;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("確定", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _itemShowing(String? option)
{
  bool isChecked = false;

  switch (option)
  {
    case 'to-do list':
      return Transform.scale
      (
        scale: 1.7,
        child: Checkbox
          (
            value: isChecked,
            onChanged: (value){}
          ),
      );
    case 'note':
      return const Icon(Icons.circle,size: 20,);
    default:
      return Container();
  }
}