import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class MovieModel extends Model {

  // Network
  void getNowPlayingMovies();
  void getPopularMovies();
  void getTopRatedMovies();
  void getMoviesByGenre(int genreId);
  void getGenres();
  void getActors();
  void getMovieDetails(int movieId);
  void getCreditsByMovie(int movieId);

  // Database
  void getTopRatedMoviesFromDatabase();
  void getNowPlayingMoviesFromDatabase();
  void getPopularMoviesFromDatabase();
  void getGenresFromDatabase();
  void getAllActorsFromDatabase();
  void getMovieDetailsFromDatabase(int movieId);

}