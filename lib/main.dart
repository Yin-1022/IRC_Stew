import 'package:flutter/material.dart';
import 'package:irc_stew/view/homepage.dart';

void main()
{
  runApp(const App());
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
