import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/persistence/persistence_constants.dart';

class MovieDao {

  static final MovieDao _singleton = MovieDao._internal();

  factory MovieDao() => _singleton;

  MovieDao._internal();

  void saveAllMovies(List<MovieVO> movieList) async {
    Map<int, MovieVO> movieMap = Map.fromIterable(
        movieList, key: (movie) => movie.id, value: (movie) => movie);
    // Map<int, MovieVO> movieMap = {
    //   for (var movie in movieList) movie.id ?? -1: movie
    // };
    await getMovieBox().putAll(movieMap);
  }

  void saveSingleMovie(MovieVO movie) async {
    await getMovieBox().put(movie.id, movie);
  }

  List<MovieVO> getAllMovies() {
    return getMovieBox().values.toList();
  }

  MovieVO? getMovieById(int movieId) {
    return getMovieBox().get(movieId);
  }

  /// Reactive programming

  Stream<void> getAllMovieEventsStream() {
    return getMovieBox().watch();
  }

  Stream<List<MovieVO>> getNowPlayingMovieStream() {
    return Stream.value(
        getAllMovies().where((movie) => movie.isNowPlaying ?? false).toList()
    );
  }

  Stream<MovieVO?> getMovieDetailStreamByMovieId(int movieId) {
    return Stream.value(getMovieById(movieId));
  }

  Stream<List<MovieVO>> getPopularMovieStream() {
    return Stream.value(
        getAllMovies().where((movie) => movie.isPopular ?? false).toList()
    );
  }

  Stream<List<MovieVO>> getTopRatedMovieStream() {
    return Stream.value(
        getAllMovies().where((movie) => movie.isTopRated ?? false).toList()
    );
  }

  List<MovieVO> getNowPlayingMovies() {
    if (getAllMovies().isNotEmpty) {
      return getAllMovies().where((element) => element.isNowPlaying ?? false).toList();
    } else {
      return [];
    }
  }

  List<MovieVO> getPopularMovies() {
    if (getAllMovies().isNotEmpty) {
      return getAllMovies().where((element) => element.isPopular ?? false).toList();
    } else {
      return [];
    }
  }

  List<MovieVO> getTopRatedMovies() {
    if (getAllMovies().isNotEmpty) {
      return getAllMovies().where((element) => element.isTopRated ?? false).toList();
    } else {
      return [];
    }
  }

  Box<MovieVO> getMovieBox() {
    return Hive.box<MovieVO>(BOX_NAME_MOVIE_VO);
  }

}