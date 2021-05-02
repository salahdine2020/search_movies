import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:search_movies_list/models/search_model.dart';

class SearchMovies{
  static String url =  "https://api.themoviedb.org/3";
  static String search_movie = 'search';
  static String apiKey = 'bc5eb692d247243c370552b98dbea40e';//Amel : 'b585314f804ab415a8f01d1fe78d4e7e';

  Dio dio = Dio(
    BaseOptions(
    //baseUrl: 'https://www.xx.com/api',
    connectTimeout: 5000,
    receiveTimeout: 3000,
    ),
  );

  Future SearchMovie(String movie_name) async {
    try{
      String link = '$url/$search_movie/movie?api_key=$apiKey&query=$movie_name';
      var url_link = Uri.parse(link);
      print('------------ complet link : $link -------------');
      /// var response = await Dio().get('$url/$search_movie/movie?$apiKey&query=$movie_name');
      var response = await http.get(url_link);
      var body = json.decode(response.body);
      print('------------ response code : ${response.statusCode} -------------');
      //print('------------ response data :${body} -------------');
      var resultat = SearchModel.fromJson(body);
      var list_film = resultat.results[0];
      print('------------ response data :${resultat.results[0].title} -------------');
      return list_film;
    } catch(e){
       print('le errur qui trouve $e');
    }
  }
}