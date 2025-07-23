import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flickd_app/pages/splash_page.dart';
import 'package:flickd_app/pages/main_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flickd',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AppEntry(),
    ),
  );
}

class AppEntry extends StatefulWidget {
  @override
  _AppEntryState createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _initialized = false;

  void _onInitializationComplete() {
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return SplashPage(
        key: UniqueKey(),
        onInitializationComplete: _onInitializationComplete,
      );
    } else {
      return MainPage();
    }
  }
}
