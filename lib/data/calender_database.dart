import 'package:hive_flutter/hive_flutter.dart';
import 'package:irc_stew/model/event.dart';

class DataBase
{
  List<Event> eventList = [];

  final _dataBox = Hive.box('dataBox');

  void createInitialData()
  {
    eventList=[Event("預設項目", "to-do list")];
  }

  void loadData()
  {
    eventList = _dataBox.get("eventList");
  }

  void updateDataBase()
  {
    _dataBox.put("eventList", eventList);
  }
}