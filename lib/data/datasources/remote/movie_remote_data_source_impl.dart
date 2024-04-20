import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/core/errors/server_exception.dart';
import 'package:movie_app/core/errors/server_failure.dart';
import 'package:movie_app/data/datasources/movie_remote_data_source.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:dartz/dartz.dart';


class MovieRemoteDataSourceImpl implements MovieRemoteDataSource{
  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  static const BASE_URL = "https://api.themoviedb.org/3";
  static const API_KEY = "dc228d68bf654d2b8d95fa8652572c8e";

  @override
  Future<List<MovieModel>> getPopularMovies() async {
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