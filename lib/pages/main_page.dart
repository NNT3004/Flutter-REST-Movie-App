import 'dart:ui';

import 'package:flickd_app/controllers/main_page_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flickd_app/models/search_category.dart';
import 'package:flickd_app/models/movie.dart';
import 'package:flickd_app/models/app_config.dart';
import 'package:flickd_app/widgets/movie_tile.dart';
import 'package:flickd_app/models/main_page_data.dart';

final MainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>((ref) {
      return MainPageDataController();
    });

class MainPage extends ConsumerWidget {
  late double _deviceHeight;
  late double _deviceWidth;

  late MainPageDataController _mainPageDataController;
  late MainPageData _mainPageData;

  late TextEditingController _searchTextFieldController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _mainPageDataController = ref.watch(
      MainPageDataControllerProvider.notifier,
    );
    _mainPageData = ref.watch(MainPageDataControllerProvider);

    _searchTextFieldController = TextEditingController();

    _searchTextFieldController.text = _mainPageData.searchText;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [_backgroundWidget(), _foregroundWidget()],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(
            'https://images-na.ssl-images-amazon.com/images/I/91B32iU7ayL._AC_SL1500_.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
        ),
      ),
    );
  }

  Widget _foregroundWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, _deviceHeight * 0.02, 0, 0),
      width: _deviceWidth * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(),
          Container(
            height: _deviceHeight * 0.82,
            padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
            child: _movieListViewWidget(),
          ),
        ],
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _deviceHeight * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_searchFieldWidget(), _categorySelectionWidget()],
      ),
    );
  }

  Widget _searchFieldWidget() {
    final _border = InputBorder.none;
    return Container(
      width: _deviceWidth * 0.50,
      height: _deviceHeight * 0.05,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (_input) => 
          _mainPageDataController.updateTextSearch(_input),
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: _border,
          border: _border,
          prefixIcon: Icon(Icons.search, color: Colors.white24),
          hintStyle: TextStyle(color: Colors.white54),
          filled: false,
          fillColor: Colors.white24,
          hintText: 'Search....',
        ),
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: _mainPageData.searchCategory,
      icon: Icon(Icons.menu, color: Colors.white24),
      underline: Container(height: 1, color: Colors.white24),
      onChanged: (_value) => _value.toString().isNotEmpty 
        ? _mainPageDataController.updateSearchCategory(_value.toString()) 
        : null,
      items: [
        DropdownMenuItem(
          child: Text(
            SearchCategory.popular,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.popular,
        ),

        DropdownMenuItem(
          child: Text(
            SearchCategory.upcoming,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.upcoming,
        ),

        DropdownMenuItem(
          child: Text(
            SearchCategory.none,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.none,
        ),
      ],
    );
  }

  Widget _movieListViewWidget() {
    final List<Movie> _movie = _mainPageData.movies;

    if (_movie.length != 0) {
      return NotificationListener(
        onNotification: (_onScrollNotification) {
          if (_onScrollNotification is ScrollEndNotification) {
            final before = _onScrollNotification.metrics.extentBefore;
            final max = _onScrollNotification.metrics.maxScrollExtent;
            if(before == max) {
              _mainPageDataController.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
        itemCount: _movie.length,
        itemBuilder: (BuildContext _context, int _count) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: _deviceHeight * 0.01,
              horizontal: 0,
            ),
            child: GestureDetector(
              onTap: () {},
              child: MovieTile(
                movie: _movie[_count],
                height: _deviceHeight * 0.2,
                width: _deviceWidth * 0.85,
              ),
            ),
          );
        },
      ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(backgroundColor: Colors.white),
      );
    }
  }
}
