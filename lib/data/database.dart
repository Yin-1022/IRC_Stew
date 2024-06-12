import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:irc_stew/model/wheel.dart';

class DataBase
{
  List wheelList = [];

  final _dataBox = Hive.box('dataBox');

  void createInitialData()
  {
    wheelList = [
      Wheel(id: 0, content: "hey", color: Colors.red.shade300),
      Wheel(id: 1, content: "he", color: Colors.blue.shade300)
    ];
  }

  void loadData()
  {
    wheelList = _dataBox.get("wheelList");
  }

  void updateDataBase()
  {
    _dataBox.put("wheelList", wheelList);
  }
}