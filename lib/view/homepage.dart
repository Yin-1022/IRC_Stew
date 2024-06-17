import 'package:flutter/material.dart';
import 'package:irc_stew/view/spinning_wheel_page.dart';
import 'package:irc_stew/view/converter_pages/converter_main.dart';
import 'package:irc_stew/view/calender_page.dart';


class HomePage extends StatefulWidget
{
  const HomePage ({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      backgroundColor: Colors.blueGrey[600],
      resizeToAvoidBottomInset : false,
      body: const Column
      (
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            SizedBox(height: 70),
            Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
              [
                ButtonBox(boxSize: 150, boxText:"轉盤" , boxIcon: Icons.settings_backup_restore, destination: SpinWheel()),
                ButtonBox(boxSize: 150, boxText:"換算" , boxIcon: Icons.calculate, destination: Currency()),
              ],
            ),
            SizedBox(height: 50),
            Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
              [
                ButtonBox(boxSize: 150, boxText:"行事曆" , boxIcon: Icons.calendar_month, destination: Calendar()),
                ButtonBox(boxSize: 150, boxText:"開銷" , boxIcon: Icons.bar_chart, destination: Currency()),
              ],
            ),
            SizedBox(height: 50),
            ButtonBox(boxSize: 200, boxText:"天氣" , boxIcon: Icons.sunny, destination: SpinWheel()),
          ],
      ),
    );
  }
}

class ButtonBox extends StatelessWidget
{
  const ButtonBox
  ({
    super.key,
    required this.boxSize,
    required this.boxIcon,
    required this.boxText,
    required this.destination,
  });

  final double boxSize;
  final IconData boxIcon;
  final String boxText;
  final Widget destination;

  @override
  Widget build(BuildContext context)
  {
    return InkWell
    (
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Stack
      (
        children:
        [
          Ink
          (
              height: boxSize,
              width: boxSize,
              decoration: const BoxDecoration
                (
                shape: BoxShape.circle,
                color: Colors.grey,
              )
          ),
          Ink
          (
            height: boxSize,
            width: boxSize,
            decoration: const BoxDecoration
            (
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Icon(boxIcon, size: 70,),
                Center(child: Text(boxText, style: const TextStyle(fontSize: 30),)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
