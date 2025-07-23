import 'package:flickd_app/models/app_config.dart';
import 'package:get_it/get_it.dart';
import 'dart:ui';
import 'package:flickd_app/models/movie.dart';
import 'package:flickd_app/models/app_config.dart';

class Movie {
  final String name;
  final String language;
  final bool isAdult;
  final String description;
  final String posterPath;
  final String backdropPath;
  final num rating;
  final String releaseDate;

  Movie({
    required this.name,
    required this.language,
    required this.isAdult,
    required this.description,
    required this.posterPath,
    required this.backdropPath,
    required this.rating,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> _json) {
    return Movie(
      name: _json['title'] as String,
      language: _json['original_language'] as String,
      isAdult: _json['adult'] as bool,
      description: _json['overview'] as String,
      posterPath: _json['poster_path'] as String,
      backdropPath: _json['backdrop_path'] as String,
      rating: _json['rating'] as num,
      releaseDate: _json['release_date'] as String,
    );
  }

  String posterURL(){
    final AppConfig _appConfig = GetIt.instance.get<AppConfig>();
    return '${_appConfig.BASE_IMAGE_API_URL}${this.posterPath}';
  }
}