import 'package:http/http.dart' as http;
import 'package:irc_stew/model/json_converter.dart';

class ApiClientCurrency
{
  String key = "d68389579df24d8197017d13a3204314";

  Future<Map> getCurrencies() async
  {
    var res = await http.get(Uri.parse("https://openexchangerates.org/api/currencies.json?base=USD&app_id=d68389579df24d8197017d13a3204314"));
    final allCurrencies = allCurrenciesFromJson(res.body);
    return allCurrencies;
  }

  Future<RatesModel> getRates() async
  {
    var res = await http.get(Uri.parse("https://openexchangerates.org/api/latest.json?base=USD&app_id=d68389579df24d8197017d13a3204314"));
    final result = ratesModelFromJson(res.body);
    return result;
  }
}

