import 'dart:convert';

import 'package:http/http.dart';
import 'package:radiostring/services/network_services.dart';

class RadioStringService {
  NetworkService networkService = NetworkService();
  final baseUrl = 'https://api.radiostring.com/';

  getFormatedHeaders(headers) {
    return new Map<String, String>.from(headers);
  } 

  Future<Response> getCountries() async {
    return await networkService.get(baseUrl+ 'get-countries');
  }

  Future<Response> getCountryStations(id) async {
    return await networkService.get(baseUrl+ 'country/$id/stations');
  }

  Future<Response> getStations() async {
    return await networkService.get(baseUrl+ 'get-stations');
  }

  Future<Response> getNextStations(url) async {
    return await networkService.get(url);
  }
}
