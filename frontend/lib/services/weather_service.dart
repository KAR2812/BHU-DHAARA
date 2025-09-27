import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class WeatherService {
  final String apiKey = Constants.weatherApiKey;

  Future<Map<String, dynamic>?> getCurrentWeather(double lat, double lon) async {
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return null;
  }
}
