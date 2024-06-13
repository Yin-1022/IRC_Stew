import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClientCurrency
{
  final Uri currencyURL = Uri.https("api.coinbase.com","/v2/exchange-rates");

  Future<List<String>> getCurrencies() async
  {
    http.Response res = await http.get(currencyURL);
    if(res.statusCode == 200)
    {
      var body = jsonDecode(res.body);
      var list = body["rates"];
      List<String> allCurrencies = (list.keys).toList();
      return allCurrencies;
    }
    else
    {
      throw Exception("無法連上API");
    }
  }
}

