import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  static const String baseUrl =
      'https://api.restcountries.com/countries/v5';

  static const String apiKey = String.fromEnvironment(
    'REST_COUNTRIES_API_KEY',
  );

  Future<List<Country>> fetchCountries() async {
    if (apiKey.isEmpty) {
      throw Exception('API key is missing!');
    }

    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'limit': '100',
        'response_fields':
        'names.common,names.official,capitals,codes.alpha_2,region,population,flag',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      final List<dynamic> countryList =
      decodedData['data']['objects'];

      return countryList
          .map((json) => Country.fromJson(json))
          .toList();
    }

    throw Exception(
      'API Error: ${response.statusCode} - ${response.body}',
    );
  }
}
