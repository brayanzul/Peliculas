import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier{

  String _apiKey = '1865f43a0549ca50d341dd9ab8b29f49';
  String _baseUrl = 'api.themoviedb.org';
  String _lenguage = 'es-ES';

  List<Movie> onDisPlayMovies = [];
  List<Movie> popularMovies = [];

  MoviesProvider() {
    print('MoviesProvider inicializando');

    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  getOnDisplayMovies() async {
    var url = Uri.https( _baseUrl, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _lenguage,
      'page': '1'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final nowPlayingResponse = NowPlayingResponse.fromJson( response.body );

    //print( nowPlayingResponse.results[1].title );
    onDisPlayMovies = nowPlayingResponse.results;

    notifyListeners();

  }

  getPopularMovies() async {
    var url = Uri.https( _baseUrl, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _lenguage,
      'page': '1'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final popularResponse = PopularResponse.fromJson( response.body );

    //print( nowPlayingResponse.results[1].title );
    popularMovies = [ ...popularMovies, ...popularResponse.results ];
    print(popularMovies[0]);

    notifyListeners();
  }

}
