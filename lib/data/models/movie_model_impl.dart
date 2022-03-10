import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/data_agents/movie_data_agent.dart';
import 'package:movie_app/network/data_agents/retrofit_movie_data_agent_impl.dart';
import 'package:movie_app/persistence/daos/actor_dao.dart';
import 'package:movie_app/persistence/daos/genre_dao.dart';
import 'package:movie_app/persistence/daos/movie_dao.dart';
import 'package:stream_transform/stream_transform.dart';

class MovieModelImpl extends MovieModel {
  static final MovieModelImpl singleton = MovieModelImpl._internal();

  factory MovieModelImpl() => singleton;

  MovieModelImpl._internal() {
    getNowPlayingMoviesFromDatabase();
    getTopRatedMoviesFromDatabase();
    getPopularMoviesFromDatabase();
    getGenresFromDatabase();
    getAllActorsFromDatabase();
  }

  final MovieDataAgent _dataAgent = RetrofitMovieDataAgentImpl();

  /// Daos
  MovieDao mMovieDao = MovieDao();
  ActorDao mActorDao = ActorDao();
  GenreDao mGenreDao = GenreDao();

  /// State Variables for home page
  List<MovieVO>? mGetNowPlayingMovies;
  List<MovieVO>? mPopularMovies;
  List<MovieVO>? mTopRatedMovies;
  List<GenreVO>? mGenres;
  List<MovieVO>? mMoviesByGenre;
  List<ActorVO>? mActors;

  /// State Variable for movie details page
  MovieVO? movieDetails;
  List<ActorVO>? cast;
  List<ActorVO>? crew;

  /// Network
  @override
  void getNowPlayingMovies() {
    _dataAgent.getNowPlayingMovies(1).then((movies) async {
      List<MovieVO> nowPlayingMovie = movies?.map((movie) {
            var movieFromHive = mMovieDao.getMovieById(movie.id ?? -1);
            if (movieFromHive != null) {
              movieFromHive.isNowPlaying = true;
              return movieFromHive;
            } else {
              movie.isNowPlaying = true;
              return movie;
            }
          }).toList() ??
          [];
      mMovieDao.saveAllMovies(nowPlayingMovie);
      mGetNowPlayingMovies = nowPlayingMovie;
      notifyListeners();
    });
  }

  @override
  void getPopularMovies() {
    _dataAgent.getPopularMovies(1).then((movies) async {
      List<MovieVO> popularMovie = movies?.map((movie) {
            var movieFromHive = mMovieDao.getMovieById(movie.id ?? -1);
            if (movieFromHive != null) {
              movieFromHive.isPopular = true;
              return movieFromHive;
            } else {
              movie.isPopular = true;
              return movie;
            }
          }).toList() ??
          [];
      mMovieDao.saveAllMovies(popularMovie);
      mPopularMovies = popularMovie;
      notifyListeners();
    });
  }

  @override
  void getTopRatedMovies() {
    _dataAgent.getTopRatedMovies(1).then((movies) async {
      List<MovieVO> topRatedMovie = movies?.map((movie) {
            var movieFromHive = mMovieDao.getMovieById(movie.id ?? -1);
            if (movieFromHive != null) {
              movieFromHive.isTopRated = true;
              return movieFromHive;
            } else {
              movie.isTopRated = true;
              return movie;
            }
          }).toList() ??
          [];
      mMovieDao.saveAllMovies(topRatedMovie);
      mTopRatedMovies = topRatedMovie;
      notifyListeners();
    });
  }

  @override
  void getActors() {
    _dataAgent.getActors(1).then((actors) async {
      mActorDao.saveAllActors(actors ?? []);
      mActors = actors;
      notifyListeners();
    });
  }

  @override
  void getGenres() {
    _dataAgent.getGenres().then((genres) async {
      mGenreDao.saveAllGenres(genres ?? []);
      mGenres = genres;
      getMoviesByGenre(genres?.first.id ?? -1);
      notifyListeners();
    });
  }

  @override
  void getMoviesByGenre(int genreId) {
    _dataAgent.getMoviesByGenre(genreId).then((moviesByGenre) {
      mMoviesByGenre = moviesByGenre;
      notifyListeners();
    });
  }

  @override
  void getCreditsByMovie(int movieId) {
    _dataAgent.getCreditsByMovie(movieId).then((credits) {
      cast = credits.first;
      crew = credits[1];
      notifyListeners();
    });
  }

  @override
  void getMovieDetails(int movieId) {
    _dataAgent.getMovieDetails(movieId).then((movie) async {
      mMovieDao.saveSingleMovie(movie!);
      movieDetails = movie;
      notifyListeners();
    });
  }

  /// Database
  @override
  void getAllActorsFromDatabase() {
    getActors();
    mActorDao
        .getAllEventsFromActorBox()
        .startWith(mActorDao.getAllActorsStream())
        .map((event) => mActorDao.getAllActors())
        .listen((actors) {
      mActors = actors;
      notifyListeners();
    });
  }

  @override
  void getGenresFromDatabase() {
    getGenres();
    mGenreDao
        .getAllEventsFromGenreBox()
        .startWith(mGenreDao.getAllGenresStream())
        .map((event) => mGenreDao.getAllGenres())
        .listen((genres) {
      mGenres = genres;
      notifyListeners();
    });
  }

  @override
  void getMovieDetailsFromDatabase(int movieId) {
    getMovieDetails(movieId);
    mMovieDao.getAllMovieEventsStream()
    .startWith(mMovieDao.getMovieDetailStreamByMovieId(movieId))
    .map((event) => mMovieDao.getMovieById(movieId))
    .listen((movie) {
      movieDetails = movie;
      notifyListeners();
    });
  }

  @override
  void getNowPlayingMoviesFromDatabase() {
    getNowPlayingMovies();
    mMovieDao
        .getAllMovieEventsStream()
        .startWith(mMovieDao.getNowPlayingMovieStream())
        .map((event) => mMovieDao.getNowPlayingMovies())
        .listen((nowPlayingMovies) {
      mGetNowPlayingMovies = nowPlayingMovies;
      notifyListeners();
    });
  }

  @override
  void getPopularMoviesFromDatabase() {
    getPopularMovies();
    mMovieDao
        .getAllMovieEventsStream()
        .startWith(mMovieDao.getPopularMovieStream())
        .map((event) => mMovieDao.getPopularMovies())
        .listen((popularMovies) {
      mPopularMovies = popularMovies;
      notifyListeners();
    });
  }

  @override
  void getTopRatedMoviesFromDatabase() {
    getTopRatedMovies();
    mMovieDao
        .getAllMovieEventsStream()
        .startWith(mMovieDao.getTopRatedMovieStream())
        .map((event) => mMovieDao.getTopRatedMovies())
        .listen((topRatedMovies) {
      mTopRatedMovies = topRatedMovies;
      notifyListeners();
    });
  }
}
