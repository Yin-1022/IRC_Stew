import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClientCurrency
{
  Future<List<String>> getCurrencies() async
  {
    var res = await http.get(Uri.parse('https://v6.exchangerate-api.com/v6/9498b31be2143d1a63aa767f/latest/USD'));
    if(res.statusCode == 200)
    {
      var data = json.decode(res.body);
      //var list = data["rates"];

      return data;
    }
    else
    {
      throw Exception("無法連上API");
    }
  }
}

