import 'dart:convert';

//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/core/errors/server_exception.dart';
import 'package:movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:movie_app/data/models/movie_model.dart';
//import 'package:dotenv/dotenv.dart';
class MovieRemoteDataSourceImpl implements MovieRemoteDataSource{
  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});
  //var env = DotEnv(includePlatformEnvironment: true)..load(['.env']);

  
  final BASE_URL =dotenv.env["BASE_URL"]!;
  final API_KEY = dotenv.env["API_KEY"]!;

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    print('your BASE URL is: $BASE_URL');
    final response = await client.get(
      Uri.parse("$BASE_URL/movie/popular?api_key=$API_KEY"),
    );

    if(response.statusCode == 200){
      final responseBody = json.decode(response.body);
      final List<MovieModel> movies = (responseBody['results'] as List)
        .map((movie) => MovieModel.fromJson(movie))
        .toList();
      return movies;
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    final response = await client.get(
      Uri.parse("$BASE_URL/trending/movie/day?api_key=$API_KEY"),
    );

    if(response.statusCode == 200){
      final responseBody = json.decode(response.body);
      final List<MovieModel> movies = (responseBody['results'] as List)
          .map((movie) => MovieModel.fromJson(movie))
          .toList();
      return movies;
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get(
      Uri.parse("$BASE_URL/search/movie?query=$query&api_key=$API_KEY"),
    );

    if(response.statusCode == 200){
      final responseBody = json.decode(response.body);
      final List<MovieModel> movies = (responseBody['results'] as List)
          .map((movie) => MovieModel.fromJson(movie))
          .toList();
      return movies;
    }else{
      throw ServerException();
    }
  }

}