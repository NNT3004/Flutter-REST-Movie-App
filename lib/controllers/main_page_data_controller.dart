import 'package:flickd_app/models/main_page_data.dart';
import 'package:flickd_app/models/movie.dart';
import 'package:flickd_app/models/search_category.dart';
import 'package:flickd_app/services/movie_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state]) 
    : super(state ?? MainPageData.initial()){
      getMovies();
    }
  
 
  final MovieService _movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie> _movies = [];
      _movies = await _movieService.getPopularMovies(page: state.page);
    } catch (e) {
      
    }
  }


}