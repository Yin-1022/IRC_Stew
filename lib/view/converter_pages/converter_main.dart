import 'package:flutter/material.dart';
import 'package:irc_stew/view/converter_pages/converter_currency.dart';
import 'package:irc_stew/view/converter_pages/converter_length.dart';
import 'package:irc_stew/view/converter_pages/converter_weight.dart';

class Currency extends StatefulWidget
{
  const Currency({super.key});

  @override
  State<Currency> createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency>
{
  List<String> items = ['貨幣','長度','重量'];
  String? selectedItem = '貨幣';

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      resizeToAvoidBottomInset : false,
      appBar: AppBar(title: const Text("換算"),backgroundColor: Colors.grey.shade500,),
      backgroundColor: Colors.grey.shade700,
      body: Center
      (
        child: Padding
        (
            padding: const EdgeInsets.all(30),
            child: Column
            (
              children:
              [
                Container
                (
                  width: 100,
                  decoration: BoxDecoration
                  (
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Center
                  (
                    child: DropdownButton<String>
                    (
                        dropdownColor: Colors.white,
                        value: selectedItem,
                        items: items.map
                        (
                            (item)=> DropdownMenuItem<String>
                            (
                                value: item,
                                child: Text(item, style: const TextStyle(fontSize: 24),)
                            )
                        ).toList(),
                        onChanged: (item) => setState(() => selectedItem = item),
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                _itemShowing(selectedItem)
              ],
            ),
        ),
      ),
    );
  }
}

Widget _itemShowing(String? option)
{
  switch (option)
  {
    case '貨幣':
      return CurrencyView();
    case '長度':
      return LengthView();
    case '重量':
      return WeightView();
    default:
      return Container();
  }
}




