import 'package:flutter/material.dart';

class LengthView extends StatefulWidget
{

  const LengthView({
    super.key,
  });

  @override
  State<LengthView> createState() => _LengthViewState();
}

class _LengthViewState extends State<LengthView>
{
  final TextEditingController _amountControllerUp = TextEditingController();
  final TextEditingController _amountControllerDown = TextEditingController();
  List<String> items = ["英吋","英尺","英里","毫米","公分","公尺","公里"];
  List<double> rates = [39.3701, 3.28084, 0.000621371, 1000, 100, 1, 0.001];
  double indicate = 0.0;
  String? defaultUnitUp = '公尺';
  String? defaultUnitDown = '英尺';

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
                          double amount = double.parse(value) ;
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
                      onChanged: (newValue) =>
                      {
                        defaultUnitUp = newValue!,
                        setState(() {
                        double amount = double.tryParse(_amountControllerUp.text) ?? 0;
                        _amountControllerDown.text = (amount / rates[items.indexOf(defaultUnitUp!)] * rates[items.indexOf(defaultUnitDown!)]).toStringAsFixed(6);
                        }),
                      }
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
                      onChanged: (newValue) =>
                      {
                        defaultUnitDown = newValue!,
                        setState(() {
                          if(_amountControllerUp.text != '')
                          {
                            double amount = double.tryParse(_amountControllerUp.text) ?? 0;
                            _amountControllerDown.text = (amount / rates[items.indexOf(defaultUnitUp!)] * rates[items.indexOf(defaultUnitDown!)]).toStringAsFixed(6);
                          }
                        }),
                      }
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