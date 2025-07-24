import 'package:flickd_app/models/app_config.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HttpService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  late String _base_url;
  late String _api_key;

  HttpService() {
    AppConfig config = getIt.get<AppConfig>();
    _base_url = config.BASE_API_URL;
    _api_key = config.API_KEY;
  }

  Future<Response?> get(String _path, {Map<String, dynamic>? query}) async {
    try {
      String _url = '$_base_url$_path';
      Map<String, dynamic> _query = {'api_key': _api_key, 'language': 'en-US'};
      if (query != null) {
        _query.addAll(query);
      }
      return await dio.get(_url, queryParameters: _query);
    } on DioError catch (e) {
      print('Unable to perform GET request: ${e.message}');
      print('Error details: ${e.response?.data}');
    
    }
  }
}
