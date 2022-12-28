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

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  MoviesProvider() {
    print('MoviesProvider inicializando');

    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData( String endpoint, [int page = 1] ) async {
    final url = Uri.https( _baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _lenguage,
      'page': '$page'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {

    final jsonData = await this._getJsonData('3/movie/now_playing');
    
    final nowPlayingResponse = NowPlayingResponse.fromJson( jsonData );

    //print( nowPlayingResponse.results[1].title );
    onDisPlayMovies = nowPlayingResponse.results;

    notifyListeners();

  }

  getPopularMovies() async {

    _popularPage++;
    
    final jsonData = await this._getJsonData('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromJson( jsonData );

    //print( nowPlayingResponse.results[1].title );
    popularMovies = [ ...popularMovies, ...popularResponse.results ];
    print(popularMovies[0]);

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast( int movieId ) async {

    if( moviesCast.containsKey(movieId) ) return moviesCast[movieId]!;

    print('pidiendo info al servidor - Cast');

    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromjson( jsonData );

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;

  }

  Future<List<Movie>> searchMovies( String query ) async {

    final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _lenguage,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromjson( response.body );

    return searchResponse.results;

  }

}
