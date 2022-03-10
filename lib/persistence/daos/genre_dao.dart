import 'package:hive/hive.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/persistence/persistence_constants.dart';

class GenreDao {

  static final GenreDao _singleton = GenreDao._internal();

  factory GenreDao() => _singleton;

  GenreDao._internal();

  void saveAllGenres(List<GenreVO> genreList) async {
    Map<int, GenreVO> genreMap = {
      for (var genre in genreList) genre.id ?? -1: genre
    };
    await getGenreBox().putAll(genreMap);
  }

  List<GenreVO> getAllGenres() {
    return getGenreBox().values.toList();
  }

  /// reactive programming

  Stream<void> getAllEventsFromGenreBox() {
    return getGenreBox().watch();
  }

  Stream<List<GenreVO>> getAllGenresStream() {
    return Stream.value(getAllGenres());
  }

  Box<GenreVO> getGenreBox() {
    return Hive.box<GenreVO>(BOX_NAME_GENRE_VO);
  }

}