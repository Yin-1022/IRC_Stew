import 'package:flutter/material.dart';
import 'package:irc_stew/model/json_converter.dart';
import 'package:irc_stew/view/service/api_client.dart';

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
  ApiClientCurrency client = ApiClientCurrency();
  List<String> currencies = [];
  List<String> countries = [];
  String? providedCountry = 'TWD';
  String? goalCountry = 'USD';
  late Future<RatesModel> result;
  late Future<Map> allCurrencies;

  @override
  void initState()
  {
    super.initState();
    setState(() {
      result = client.getRates();
      allCurrencies = client.getCurrencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Center
    (
      child: Column
      (
        children:
        [
          Container
          (
            width: h,
            height: 50,
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
                value: providedCountry,
                items: countries.map
                (
                    (item)=> DropdownMenuItem<String>
                    (
                        value: item,
                        child: Text(item, style: const TextStyle(fontSize: 24),)
                    )
                ).toList(),
                onChanged: (item) => setState(() => currencies = item as List<String>),
              ),
            ),
          ),
        ],
      ),
    );
  }
}