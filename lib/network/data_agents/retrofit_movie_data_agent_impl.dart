import 'package:dio/dio.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/api_constants.dart';
import 'package:movie_app/network/the_movie_api.dart';

import 'movie_data_agent.dart';

class RetrofitMovieDataAgentImpl extends MovieDataAgent {
  late TheMovieApi mApi;

  static final RetrofitMovieDataAgentImpl singleton =
      RetrofitMovieDataAgentImpl._internal();

  factory RetrofitMovieDataAgentImpl() => singleton;

  RetrofitMovieDataAgentImpl._internal() {
    final dio = Dio();
    mApi = TheMovieApi(dio);
  }

  @override
  Future<List<MovieVO>?> getNowPlayingMovies(int page) {
    return mApi
        .getNowPlayingMovies(API_KEY, LANGUAGE_EN_US, page.toString())
        .asStream()
        .map((response) => response.results)
        .first;
  }

  @override
  Future<List<ActorVO>?> getActors(int page) {
    return mApi
        .getActors(API_KEY, LANGUAGE_EN_US, page.toString())
        .asStream()
        .map((response) => response.results)
        .first;
  }

  @override
  Future<List<GenreVO>?> getGenres() {
    return mApi
        .getGenres(API_KEY, LANGUAGE_EN_US)
        .asStream()
        .map((response) => response.genres)
        .first;
  }

  @override
  Future<List<MovieVO>?> getMoviesByGenre(int genreId) {
    return mApi
        .getMoviesByGenre(genreId.toString(), API_KEY, LANGUAGE_EN_US)
        .asStream()
        .map((response) => response.results)
        .first;
  }

  @override
  Future<List<MovieVO>?> getPopularMovies(int page) {
    return mApi
        .getNowPlayingMovies(API_KEY, LANGUAGE_EN_US, page.toString())
        .asStream()
        .map((response) => response.results)
        .first;
  }

  @override
  Future<List<MovieVO>?> getTopRatedMovies(int page) {
    return mApi
        .getNowPlayingMovies(API_KEY, LANGUAGE_EN_US, page.toString())
        .asStream()
        .map((response) => response.results)
        .first;
  }

  @override
  Future<List<List<ActorVO>?>> getCreditsByMovie(int movieId) {
    return mApi
        .getCreditsByMovie(movieId.toString(), API_KEY)
        .asStream()
        .map((creditsByMovieResponse) =>
            [creditsByMovieResponse?.cast, creditsByMovieResponse?.crew])
        .first;
  }

  @override
  Future<MovieVO?> getMovieDetails(int movieId) {
    return mApi.getMovieDetails(movieId.toString(), API_KEY);
  }
}
