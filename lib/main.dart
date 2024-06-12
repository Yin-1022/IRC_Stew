import 'package:flutter/material.dart';
import 'package:irc_stew/model/wheel.dart';
import 'package:irc_stew/view/homepage.dart';
import 'package:hive_flutter/adapters.dart';

void main() async
{
  await Hive.initFlutter();

  runApp(const App());

  Hive.registerAdapter(WheelAdapter());
  Hive.registerAdapter(ColorAdapter());
  await Hive.openBox('dataBox');
}

class App extends StatefulWidget
{
  const App({super.key});

  @override
  State<App> createState() => _HomePageState();
}

class _HomePageState extends State<App>
{
  @override
  Widget build(BuildContext context)
  {
    return const MaterialApp
      (
      home: HomePage(),
    );
  }
}
