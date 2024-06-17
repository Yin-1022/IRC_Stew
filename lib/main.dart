import 'package:flutter/material.dart';
import 'package:irc_stew/data/expense_database.dart';
import 'package:irc_stew/model/wheel.dart';
import 'package:irc_stew/view/homepage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';


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
    return ChangeNotifierProvider
    (
        create: (context) => ExpenseDatabase(),
        builder: (context, child) => const MaterialApp
        (
          localizationsDelegates:
          [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales:
          [
            Locale('en', ''),
            Locale('tw', ''),
          ],

          home: HomePage(),
        ),
    );
  }
}
