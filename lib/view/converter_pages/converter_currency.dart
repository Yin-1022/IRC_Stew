import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyView extends StatefulWidget
{

  const CurrencyView({
    super.key,
  });

  @override
  State<CurrencyView> createState() => _CurrencyViewState();
}

class _CurrencyViewState extends State<CurrencyView>
{
  final TextEditingController _amountControllerUp = TextEditingController();
  final TextEditingController _amountControllerDown = TextEditingController();
  double rate = 0.0;
  List<String> engCurrencies = ["TWD","DKK","USD","HKD","MYR","INR","JPY","KRW","CNY","GBP","EUR"];
  List<String> indication = ["台幣","丹麥克朗","美金","港幣","馬來幣","印度盧比","日幣","韓幣","人民幣","英鎊","歐元",];
  String? startCurrency = '台幣';
  String? toCurrency = '美金';

  @override
  void initState()
  {
    super.initState();
    _getCurrencies();
    _getRates();
  }

  Future<void> _getCurrencies() async
  {
    var res = await http.get(Uri.parse('https://v6.exchangerate-api.com/v6/9498b31be2143d1a63aa767f/latest/USD'));
    if(res.statusCode == 200)
    {
      var data = json.decode(res.body);

      setState(() {
        rate = data['conversion_rates'][engCurrencies[indication.indexOf(toCurrency!)]];
      });
    }
    else
    {
      throw Exception("無法連上API");
    }
  }

  Future<void> _getRates() async
  {
    var res = await http.get(Uri.parse('https://v6.exchangerate-api.com/v6/9498b31be2143d1a63aa767f/latest/${engCurrencies[indication.indexOf(startCurrency!)]}'));
    if(res.statusCode == 200)
    {
      var data = json.decode(res.body);

      setState(() {
        rate = data['conversion_rates'][engCurrencies[indication.indexOf(toCurrency!)]];

      });
    }
    else
    {
      throw Exception("無法連上API");
    }
  }

  void _swapCurrencies()
  {
    setState(() {
      String? temp = startCurrency;
      startCurrency = toCurrency;
      toCurrency = temp;
      temp = _amountControllerUp.text;
      _amountControllerUp.text = _amountControllerDown.text;
      _amountControllerDown.text = temp;
      _getRates();
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
                      decoration: const InputDecoration(hintText: "輸入數字", hintStyle: TextStyle(fontSize:25)),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: _amountControllerUp,
                      onChanged: (value)
                      {
                        if(value != '')
                        {
                          double amount = double.parse(value);
                          _amountControllerDown.text = (amount * rate).toStringAsFixed(6);
                        }
                      },
                    ),
                  ),
                ),
                Flexible
                  (
                  flex: 3,
                  child: Center
                    (
                    child: DropdownButton<String>
                      (
                        menuMaxHeight: 500,

                        isExpanded: true,
                        dropdownColor: Colors.white,
                        value: startCurrency,
                        items: indication.map
                          (
                                (String value)=> DropdownMenuItem<String>
                              (
                                value: value,
                                child: Text(value, style: const TextStyle(fontSize: 21),)
                            )
                        ).toList(),
                        onChanged: (newValue) async =>
                        {
                          startCurrency = newValue!,
                          await _getRates(),
                          setState(()  {
                            double amount = double.parse(_amountControllerUp.text);
                            _amountControllerDown.text = (amount * rate).toStringAsFixed(6);
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
                      decoration: const InputDecoration(hintText: "輸入數字", hintStyle: TextStyle(fontSize: 25)),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: _amountControllerDown,
                      onChanged: (value)
                      {
                        if(value != '')
                        {
                          double amount = double.parse(value);
                          _amountControllerUp.text = (amount / rate).toStringAsFixed(6);
                        }
                      },
                    ),
                  ),
                ),
                Flexible
                  (
                  flex: 3,
                  child: Center
                    (
                    child: DropdownButton<String>
                      (
                        menuMaxHeight: 500,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        value: toCurrency,
                        items: indication.map
                          (
                                (String value)=> DropdownMenuItem<String>
                              (
                                value: value,
                                child: Text(value, style: const TextStyle(fontSize: 21),)
                            )
                        ).toList(),
                        onChanged: (newValue) async => {
                          toCurrency = newValue!,
                          await _getRates(),
                          setState(()  {
                            if(_amountControllerUp.text != '')
                            {
                              double amount = double.parse(_amountControllerUp.text);
                              _amountControllerDown.text = (amount * rate).toStringAsFixed(6);
                            }
                          }),
                        }
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 40,),
          Text("1 $startCurrency = $rate $toCurrency", style: const TextStyle(fontSize: 29, color: Colors.white)),
        ],
      ),
    );
  }
}