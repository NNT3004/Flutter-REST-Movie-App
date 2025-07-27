import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flickd_app/pages/splash_page.dart';
import 'package:flickd_app/pages/main_page.dart';
import 'package:get_it/get_it.dart';
import 'package:flickd_app/models/app_config.dart';
import 'package:flickd_app/services/movie_service.dart';
import 'package:flickd_app/services/http_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo AppConfig (bạn có thể thay đổi giá trị cho phù hợp)
  final appConfig = AppConfig(
    BASE_API_URL: 'https://api.themoviedb.org/3/',
    BASE_IMAGE_API_URL: 'https://image.tmdb.org/t/p/w500/',
    API_KEY: 'YOUR_API_KEY',
  );

  // Đăng ký với GetIt
  if (!GetIt.instance.isRegistered<AppConfig>()) {
    GetIt.instance.registerSingleton<AppConfig>(appConfig);
  }
  if (!GetIt.instance.isRegistered<HttpService>()) {
    GetIt.instance.registerSingleton<HttpService>(HttpService());
  }
  if (!GetIt.instance.isRegistered<MovieService>()) {
    GetIt.instance.registerSingleton<MovieService>(MovieService());
  }

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Flickd',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AppEntry(),
      ),
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
