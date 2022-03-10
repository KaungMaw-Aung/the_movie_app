import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/pages/movie_details_page.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/resources/strings.dart';
import 'package:movie_app/viewitems/banner_view.dart';
import 'package:movie_app/viewitems/movie_view.dart';
import 'package:movie_app/viewitems/show_case_view.dart';
import 'package:movie_app/widgets/actors_and_creators_section_view.dart';
import 'package:movie_app/widgets/see_more_text.dart';
import 'package:movie_app/widgets/title_text_view.dart';
import 'package:movie_app/widgets/title_text_with_see_more_view.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        title: const Text(
          MAIN_SCREEN_APP_BAR_TITLE,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        leading: const Icon(Icons.menu),
        actions: const [
          Padding(
            padding: EdgeInsets.only(
                top: 0, bottom: 0, left: 0, right: MARGIN_MEDIUM_2),
            child: Icon(Icons.search),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        color: HOME_SCREEN_BACKGROUND_COLOR,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScopedModelDescendant<MovieModelImpl>(builder:
                  (BuildContext context, Widget? child, MovieModelImpl model) {
                return BannerSectionView(
                    movieList: model.mPopularMovies?.take(5).toList());
              }),
              const SizedBox(
                height: MARGIN_LARGE,
              ),
              ScopedModelDescendant<MovieModelImpl>(
                builder: (BuildContext context, Widget? child,
                    MovieModelImpl model) {
                  return BestPopularMoviesAndSerialsSectionView(
                    onTapMovie: (movieId) =>
                        navigateToMovieDetailScreen(context, movieId, model),
                    nowPlayingMovies: model.mGetNowPlayingMovies,
                  );
                },
              ),
              const SizedBox(
                height: MARGIN_LARGE,
              ),
              const CheckMovieShowtimeSectionView(),
              const SizedBox(
                height: MARGIN_LARGE,
              ),
              ScopedModelDescendant<MovieModelImpl>(
                builder: (BuildContext context, Widget? child,
                    MovieModelImpl model) {
                  return GenreSectionView(
                    (movieId) => navigateToMovieDetailScreen(
                      context,
                      movieId,
                      model,
                    ),
                    genreList: model.mGenres,
                    moviesByGenre: model.mMoviesByGenre,
                    onChooseGenre: (genreId) {
                      if (genreId != null) {
                        model.getMoviesByGenre(genreId);
                      }
                    },
                  );
                },
              ),
              const SizedBox(
                height: MARGIN_LARGE,
              ),
              ScopedModelDescendant<MovieModelImpl>(
                builder: (BuildContext context, Widget? child,
                    MovieModelImpl model) {
                  return ShowcasesSection(movieList: model.mTopRatedMovies);
                },
              ),
              const SizedBox(
                height: MARGIN_LARGE,
              ),
              ScopedModelDescendant<MovieModelImpl>(
                builder: (BuildContext context, Widget? child,
                    MovieModelImpl model) {
                  return ActorsAndCreatorsSectionView(
                    BEST_ACTORS_TITLE,
                    BEST_ACTORS_SEE_MORE,
                    actors: model.mActors,
                  );
                },
              ),
              const SizedBox(
                height: MARGIN_LARGE,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToMovieDetailScreen(
      BuildContext context, int? movieId, MovieModelImpl model) {
    if (movieId != null) {
      model.getMovieDetailsFromDatabase(movieId);
      model.getCreditsByMovie(movieId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailsPage(),
        ),
      );
    }
  }
}

class GenreSectionView extends StatelessWidget {
  final List<GenreVO>? genreList;
  final List<MovieVO>? moviesByGenre;
  final Function(int?) onTapMovie;
  final Function(int?) onChooseGenre;

  GenreSectionView(
    this.onTapMovie, {
    required this.genreList,
    required this.moviesByGenre,
    required this.onChooseGenre,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: DefaultTabController(
            length: genreList?.length ?? 0,
            child: TabBar(
              isScrollable: true,
              indicatorColor: PLAY_BUTTON_COLOR,
              unselectedLabelColor: HOME_SCREEN_LIST_TITLE_COLOR,
              tabs: genreList
                      ?.map(
                        (genre) => Tab(
                          child: Text(genre.name ?? ""),
                        ),
                      )
                      .toList() ??
                  [],
              onTap: (index) => onChooseGenre(genreList?[index].id),
            ),
          ),
        ),
        Container(
          color: PRIMARY_COLOR,
          child: Padding(
            padding: const EdgeInsets.only(
                top: MARGIN_MEDIUM_2, bottom: MARGIN_LARGE),
            child: HorizontalMovieListView(
                onTapMovie: onTapMovie, movieList: moviesByGenre),
          ),
        ),
      ],
    );
  }
}

class CheckMovieShowtimeSectionView extends StatelessWidget {
  const CheckMovieShowtimeSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PRIMARY_COLOR,
      height: SHOWTIME_SECTION_HEIGHT,
      margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      padding: const EdgeInsets.all(MARGIN_LARGE),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                MAIN_SCREEN_CHECK_MOVIE_SHOWTIME,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: TEXT_HEADING_1X,
                ),
              ),
              const Spacer(),
              SeeMoreText(
                MAIN_SCREEN_SEE_MORE,
                textColor: PLAY_BUTTON_COLOR,
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: BANNER_PLAY_BUTTON_SIZE,
          )
        ],
      ),
    );
  }
}

class ShowcasesSection extends StatelessWidget {
  final List<MovieVO>? movieList;

  ShowcasesSection({required this.movieList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: TitleTextWithSeeMoreView(
            SHOW_CASES_TITLE,
            SHOW_CASES_SEE_MORE,
          ),
        ),
        const SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        Container(
          height: SHOW_CASES_HEIGHT,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
            children: movieList
                    ?.map((movie) => ShowCaseView(movie: movie))
                    .toList() ??
                [],
          ),
        ),
      ],
    );
  }
}

class BestPopularMoviesAndSerialsSectionView extends StatelessWidget {
  final Function(int?) onTapMovie;
  final List<MovieVO>? nowPlayingMovies;

  BestPopularMoviesAndSerialsSectionView(
      {required this.onTapMovie, required this.nowPlayingMovies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
          child: TitleTextView(MAIN_SCREEN_BEST_POPULAR_FILMS_AND_SERIALS),
        ),
        const SizedBox(
          height: MARGIN_MEDIUM,
        ),
        HorizontalMovieListView(
            onTapMovie: onTapMovie, movieList: nowPlayingMovies),
      ],
    );
  }
}

class HorizontalMovieListView extends StatelessWidget {
  final Function(int?) onTapMovie;
  final List<MovieVO>? movieList;

  HorizontalMovieListView({required this.onTapMovie, required this.movieList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MOVIE_LIST_HEIGHT,
      child: (movieList != null)
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
              itemCount: movieList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return MovieView(
                    onTapMovie: onTapMovie, movie: movieList?[index]);
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class BannerSectionView extends StatefulWidget {
  final List<MovieVO>? movieList;

  BannerSectionView({required this.movieList});

  @override
  State<BannerSectionView> createState() => _BannerSectionViewState();
}

class _BannerSectionViewState extends State<BannerSectionView> {
  double _position = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 4,
          child: PageView(
            onPageChanged: (page) {
              setState(() {
                _position = page.toDouble();
              });
            },
            children: widget.movieList
                    ?.map((movie) => BannerView(movie: movie))
                    .toList() ??
                [],
          ),
        ),
        const SizedBox(height: MARGIN_MEDIUM_2),
        DotsIndicator(
          dotsCount: (widget.movieList?.length == 0 || widget.movieList == null)
              ? 1
              : widget.movieList!.length,
          position: _position,
          decorator: const DotsDecorator(
            color: HOME_BANNER_DOTS_INACTIVE_COLOR,
            activeColor: PLAY_BUTTON_COLOR,
          ),
        )
      ],
    );
  }
}
