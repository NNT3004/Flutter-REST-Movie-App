import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class AppConfig{
  final String BASE_API_URL;
  final String BASE_IMAGE_API_URL;
  final String API_KEY;

  AppConfig({
    required this.BASE_API_URL,
    required this.BASE_IMAGE_API_URL,
    required this.API_KEY,
  });
}