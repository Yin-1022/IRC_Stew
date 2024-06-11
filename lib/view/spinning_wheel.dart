import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:irc_stew/model/wheel.dart';
import 'package:irc_stew/model/color.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SpinWheel extends StatefulWidget
{
  const SpinWheel({super.key});

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel>
{
  final selected = BehaviorSubject<int>();
  int pressed = 0;
  String result = "";
  bool isButtonPressed = false;
  bool isMessageShown = false;
  Color _selectedColor = Colors.red;
  final TextEditingController _textFieldController = TextEditingController();

  List<Wheel> wheels =
  [
    Wheel(id: 0, content: "hey", color: Colors.red.shade300),
    Wheel(id: 1, content: "he", color: Colors.blue.shade300)
  ];

  @override
  void dispose()
  {
    selected.close();
    super.dispose();
  }

  void deleteWheel(int index)
  {
    Wheel wheel = wheels[index];
    wheels.remove(wheel);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      resizeToAvoidBottomInset : false,
      appBar: AppBar(title: const Text("轉盤")),
      body: Center
      (
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column
          (
            children:
            [
              SizedBox
              (
                height: 300,
                child: FortuneWheel
                (
                    selected: selected.stream,
                    animateFirst: false,
                    items:
                    [
                      for(int i=0; i< wheels.length; i++)...<FortuneItem>
                      {
                        FortuneItem
                        (
                            style: FortuneItemStyle(color: wheels[i].color, borderWidth: 0),
                            child: Text(wheels[i].content, style: const TextStyle(fontSize: 25)),
                            onTap:()
                            {
                              if(isButtonPressed == false)
                              {
                                pressed = i;
                                _selectedColor = wheels[pressed].color;
                                editWheel(context);
                              }
                              else
                              {
                                if(isMessageShown == false)
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請等待轉盤停下"),));
                                  isMessageShown = true;
                                }
                              }
                            }
                        )
                      }
                    ],
                    onAnimationStart: ()
                    {
                      setState(() {
                        isButtonPressed = true;
                      });
                    },
                    onAnimationEnd: ()
                    {
                      setState(() {
                        result = wheels[selected.value].content;
                        isButtonPressed = false;
                        isMessageShown = false;
                      });
                    },
                ),
              ),
              const SizedBox(height: 50),
              Ink
              (
                color: Colors.orange,
                child: InkWell
                (
                  child: const SizedBox
                  (
                    height: 40,
                    width: 120,
                    child: Center
                    (
                        child:Text("轉",style: TextStyle(fontSize: 25))
                    ),
                  ),
                  onTap: ()
                  {
                    if(isButtonPressed == false)
                    {
                      setState(() {selected.add(Fortune.randomInt(0, wheels.length));});
                    }
                  },
                ),
              ),
              const SizedBox(height: 40),
              Container
               (
                  height: 40,
                  width: 300,
                  color: Colors.teal.shade100,
                  child: const Center
                   (
                      child:Text("結果", style: TextStyle(fontSize: 25))
                  )
              ),
              Container
              (
                height: 70,
                width: 300,
                color: Colors.teal.shade200,
                  child: Center
                  (
                      child:Text(result,style: const TextStyle(fontSize: 25))
                  )
              ),
              const SizedBox(height: 60),
              Row
              (
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:
                  [
                    FloatingActionButton
                    (
                      onPressed: ()
                      {
                        if(isButtonPressed == false)
                        {
                          addWheel(context);
                          _selectedColor = Colors.red.shade300;
                        }
                        else
                        {
                          if(isMessageShown == false)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請等待轉盤停下"),));
                            isMessageShown = true;
                          }
                        }
                      },
                      child: const Icon(Icons.add, size: 35,),
                    ),
                  ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget colorPicker() => BlockPicker
  (
      pickerColor: _selectedColor,
      availableColors:usableColors,
      onColorChanged : (selectedColor) => setState(() => _selectedColor = selectedColor),
  );

  void addWheel(BuildContext context) => showDialog
  (
      barrierLabel: _textFieldController.text = "輸入文字",
      context: context,
      builder: (context) => AlertDialog
      (
        title: const Text("添加新選項"),
        content: SingleChildScrollView
        (
          child: Column
          (
            mainAxisSize: MainAxisSize.min,
            children:
            [
              TextField
              (
                decoration: const InputDecoration(hintText: "輸入文字", hintStyle: TextStyle(fontSize: 20)),
                controller: _textFieldController,
              ),
              const SizedBox(height: 30),
              colorPicker(),
              TextButton
              (
                child: const Text("確定", style: TextStyle(fontSize: 20)),
                onPressed: ()
                {
                  String wheelContext = _textFieldController.text;
                  setState(()
                  {
                    if(wheelContext != "" && wheels.length < 12)
                    {
                      Navigator.of(context).pop();
                      wheels.add
                      (
                          Wheel(id: wheels.length, content: _textFieldController.text, color: _selectedColor)
                      );
                    }
                    else if (wheels.length >= 12)
                    {
                      showDialog(context: context, builder: (BuildContext context)
                      {
                        return AlertDialog
                        (
                          title: const Text("選項最多12個，請編輯或刪除選項"),
                          actions:
                          [
                            ElevatedButton(onPressed: () {
                              Navigator.of(context).pop();
                            }, child: const Text("好的")),
                          ],
                        );
                      });
                    }
                  });
                }
              ),
            ],
          ),
        ),
      )
  );

  void editWheel(BuildContext context) => showDialog
  (
      barrierLabel: _textFieldController.text = wheels[pressed].content,
      context: context,
      builder: (context) => AlertDialog
        (
        title: const Text("編輯選項"),
        content: SingleChildScrollView
        (
          child: Column
          (
            mainAxisSize: MainAxisSize.min,
            children:
            [
              TextField
              (
                controller: _textFieldController,
                decoration: InputDecoration(hintText: wheels[pressed].content, hintStyle: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 30),
              colorPicker(),
              Row
              (
                mainAxisAlignment: MainAxisAlignment.end,
                children:
                [
                  IconButton
                  (
                      onPressed: ()
                      {
                        if(wheels.length>2)
                        {
                          deleteWheel(pressed);
                          Navigator.of(context).pop();
                        }
                        else
                        {
                          showDialog(context: context, builder: (BuildContext context)
                          {
                            return AlertDialog
                            (
                              title: const Text("選項數量=2時不可刪除"),
                              actions:
                              [
                                ElevatedButton(onPressed: () {
                                  Navigator.of(context).pop();
                                }, child: const Text("好的")),
                              ],
                            );
                          });
                        }
                      },
                      icon: const Icon(Icons.delete, size: 40,)
                  ),
                ],
              ),
              TextButton
              (
                  child: const Text("確定", style: TextStyle(fontSize: 20)),
                  onPressed: ()
                  {
                    String wheelContext = _textFieldController.text;
                    setState(()
                    {
                      if(wheelContext != "")
                      {
                        wheels[pressed].content = wheelContext;
                        wheels[pressed].color = _selectedColor;
                      }
                    });
                    Navigator.of(context).pop();
                  }
              ),
            ],
          ),
        ),
      )
  );
}



