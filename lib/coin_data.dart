import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  static const String _baseUrl = 'https://rest.coinapi.io/v1/exchangerate/';
  static const String _apiKey = "XY";

  Future<double> getRate(String source, String target) async {
    var url = _baseUrl + source + '/' + target;
    var response = await http.get(url, headers: {'X-CoinAPI-Key': _apiKey});
    var json = jsonDecode(response.body);
    return json['rate'] as double;
  }
}
