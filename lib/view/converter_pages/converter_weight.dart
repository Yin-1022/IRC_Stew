import 'package:flutter/material.dart';

class WeightView extends StatefulWidget
{

  const WeightView({
    super.key,
  });

  @override
  State<WeightView> createState() => _WeightViewState();
}

class _WeightViewState extends State<WeightView>
{
  final TextEditingController _amountControllerUp = TextEditingController();
  final TextEditingController _amountControllerDown = TextEditingController();
  List<String> items = ["磅","台斤","公克","公斤","公噸"];
  List<double> rates = [2.2046226218 , 1.6666666667, 1000, 1, 0.001];
  String? defaultUnitUp = '公斤';
  String? defaultUnitDown = '公克';

  @override
  void initState()
  {
    super.initState();
  }

  void _swapCurrencies()
  {
    setState(() {
      String? temp = defaultUnitUp;
      defaultUnitUp = defaultUnitDown;
      defaultUnitDown = temp;
      temp = _amountControllerUp.text;
      _amountControllerUp.text = _amountControllerDown.text;
      _amountControllerDown.text = temp;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Center
      (
      child: Column
        (
        children:
        [
          const SizedBox(height: 30,),
          Container
          (
            width: 300,
            height: 100,
            decoration: BoxDecoration
              (
              border: Border.all(color: Colors.grey),
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Row
              (
              children:
              [
                Flexible
                (
                  flex: 5,
                  child: Padding
                    (
                    padding: const EdgeInsets.all(10),
                    child: TextField
                    (
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(hintText: "輸入數字", hintStyle: TextStyle(fontSize: 20)),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: _amountControllerUp,
                      onChanged: (value)
                      {
                        if(value != '')
                        {
                          double amount = double.parse(value);
                          _amountControllerDown.text = (amount / rates[items.indexOf(defaultUnitUp!)] * rates[items.indexOf(defaultUnitDown!)]).toStringAsFixed(6);
                        }
                      },
                    ),
                  ),
                ),
                Flexible
                  (
                  flex: 2,
                  child: Center
                    (
                    child: DropdownButton<String>
                      (
                      dropdownColor: Colors.white,
                      value: defaultUnitUp,
                      items: items.map
                        (
                              (String value)=> DropdownMenuItem<String>
                            (
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 24),)
                          )
                      ).toList(),
                      onChanged: (newValue) => setState(() {
                        defaultUnitUp = newValue!;
                        double amount = double.tryParse(_amountControllerUp.text)?? 0;
                        _amountControllerDown.text = (amount / rates[items.indexOf(defaultUnitUp!)] * rates[items.indexOf(defaultUnitDown!)]).toStringAsFixed(6);
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 40,),
          IconButton
          (
              onPressed: (){_swapCurrencies();},
              icon: const Icon(Icons.swap_vert,size: 90,color: Colors.white,)
          ),
          const SizedBox(height: 40,),
          Container
          (
            width: 300,
            height: 100,
            decoration: BoxDecoration
            (
              border: Border.all(color: Colors.grey),
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Row
              (
              children:
              [
                Flexible
                  (
                  flex: 5,
                  child: Padding
                    (
                    padding: const EdgeInsets.all(10),
                    child: TextField
                    (
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(hintText: "輸入數字", hintStyle: TextStyle(fontSize: 20)),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: _amountControllerDown,
                      onChanged: (value)
                      {
                        if(value != '')
                        {
                          double amount = double.parse(value);
                          _amountControllerUp.text = (amount / rates[items.indexOf(defaultUnitDown!)] * rates[items.indexOf(defaultUnitUp!)]).toStringAsFixed(6);
                        }
                      },
                    ),
                  ),
                ),
                Flexible
                  (
                  flex: 2,
                  child: Center
                    (
                    child: DropdownButton<String>
                      (
                      dropdownColor: Colors.white,
                      value: defaultUnitDown,
                      items: items.map
                        (
                           (String value)=> DropdownMenuItem<String>
                           (
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 24),)
                           )
                      ).toList(),
                      onChanged: (newValue) => setState(() {
                        defaultUnitDown = newValue!;
                        if(_amountControllerUp.text != '')
                        {
                          double amount = double.tryParse(_amountControllerUp.text)?? 0;
                          _amountControllerDown.text = (amount / rates[items.indexOf(defaultUnitUp!)] * rates[items.indexOf(defaultUnitDown!)]).toStringAsFixed(6);
                        }
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}