import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Themes/AppThemes.dart';
import '../Routes/MovieDetailsRoute.dart';
import '../Utils/Movies.dart';
import '../Utils/MovieHelper.dart';

class HomeMethods {
  static MovieHelper movieHelper = MovieHelper();
  static bool areMoviesLoaded = false;
  static ScrollController scrollController;

  static List<Movie> _topRatedMovies = [];
  static List<Movie> _mostPopularMovies = [];
  static List<Movie> _thisYearMovies = [];
  static List<Movie> _recentlyMovies = [];
  static List<Movie> _mostSeenMovies = [];

  //********************************************************** [Browse Page] Methods
  static List<Widget> getGenres(List<String> gens) {
    List<Widget> temWidgets = [];
    for (var g in gens) {
      temWidgets.add(
        Container(
          margin: const EdgeInsets.only(right: 2, top: 4),
          padding: const EdgeInsets.only(top: 3, bottom: 3, left: 6, right: 6),
          decoration: BoxDecoration(
            color: Color(0xff283442),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            g.toString(),
            style: TextStyle(
              color: Color(0xffc7c7c7),
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return temWidgets;
  }

  // Function resposible of loading image from the network
  // after the movieList futuer load completed
  static Widget loadImage(String url) {
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.white24,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '\nCouldn\'t Load.',
                  style: TextStyle(color: Colors.white24, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: 120,
          height: 200,
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  // Function return Error Loading Widget
  static Widget errorOrLoading(String errorLabel) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitCircle(
            size: 40,
            color: DarkTheme.errorProgressColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Text(
              errorLabel,
              style: TextStyle(color: DarkTheme.errorTextColor, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  static Widget bodyContent(BuildContext context, List<Movie> movies) {
    return ListView.builder(
      controller: scrollController,
      itemCount: movies.length,
      itemBuilder: (BuildContext contexter, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => MovieDetailsRouteUI(movies[index]),
              ),
            );
          },
          child: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: Container(
              margin:
                  const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: DarkTheme.movieCardColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 120,
                    height: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        child: HomeMethods.loadImage(movies[index].coverImage),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              movies[index].titleLong,
                              maxLines: 2,
                              style: TextStyle(
                                  color: DarkTheme.movieTitleColor,
                                  fontSize: 20),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color(0xfff9ca24),
                                  ),
                                ),
                                child: Text(
                                  'IMDB  ' + movies[index].rating,
                                  style: TextStyle(color: Color(0xfff9ca24)),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color(0xfff6e58d),
                                  ),
                                ),
                                child: Text(
                                  movies[index].year,
                                  style: TextStyle(
                                    color: Color(0xfff9ca24),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color(0xfff6e58d),
                                  ),
                                ),
                                child: Text(
                                  movies[index].language,
                                  style: TextStyle(color: Color(0xfff9ca24)),
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            children:
                                HomeMethods.getGenres(movies[index].genres),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                movies[index].fullDescription,
                                maxLines: 3,
                                style: TextStyle(
                                    color: DarkTheme.movieDescriptionColor,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //********************************************************** [Home Page] Methods
  static Widget topTitleBar(String leftTitle, String rightTitleButton,
      [void Function() onTap]) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            leftTitle,
            style: TextStyle(color: DarkTheme.whiteTitleColor1, fontSize: 18),
          ),
        ),
        Expanded(child: Text('')),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              rightTitleButton,
              style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildMoviesOn(
    int limit,
    int page,
    String sortBy,
    String orderBy,
    int ratingRange,
  ) {
    if (!areMoviesLoaded) {
      return FutureBuilder(
        future:
            movieHelper.getMoviesBy(limit, page, sortBy, orderBy, ratingRange),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return HomeMethods.errorOrLoading('');
          } else {
            areMoviesLoaded = true;
            switch (sortBy) {
              case 'download_count':
                _mostSeenMovies = snapshot.data;
                return _buildMovies(_mostSeenMovies);
                break;
              case 'like_count':
                _mostPopularMovies = snapshot.data;
                return _buildMovies(_mostPopularMovies);
                break;
              case 'rating':
                _topRatedMovies = snapshot.data;
                return _buildMovies(_topRatedMovies);
                break;
              case 'year':
                _thisYearMovies = snapshot.data;
                return _buildMovies(_thisYearMovies);
                break;
              case 'date_added':
                _recentlyMovies = snapshot.data;
                return _buildMovies(_recentlyMovies);
                break;
              default:
                return errorOrLoading('');
                break;
            }
          }
        },
      );
    } else {
      switch (sortBy) {
        case 'download_count':
          return _buildMovies(_mostSeenMovies);
          break;
        case 'like_count':
          return _buildMovies(_mostPopularMovies);
          break;
        case 'rating':
          return _buildMovies(_topRatedMovies);
          break;
        case 'year':
          return _buildMovies(_thisYearMovies);
          break;
        case 'date_added':
          return _buildMovies(_recentlyMovies);
          break;
        default:
          return errorOrLoading('');
          break;
      }
    }
  }

  static Widget _buildMovies(List<Movie> movies) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => MovieDetailsRouteUI(movies[index]),
              ),
            );
          },
          child: SizedBox(
            height: 250,
            width: 150,
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: DarkTheme.movieCardColor,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 180,
                    width: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: Image.network(
                          movies[index].coverImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Text(
                      movies[index].titleLong,
                      style: TextStyle(
                          color: DarkTheme.movieTitleColor, fontSize: 15),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color(0xfff9ca24),
                            ),
                          ),
                          child: Text(
                            movies[index].rating,
                            style: TextStyle(color: Color(0xfff9ca24)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color(0xfff6e58d),
                            ),
                          ),
                          child: Text(
                            movies[index].year,
                            style: TextStyle(color: Color(0xfff9ca24)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // this is the top part of the [Home Page] which
  // used to build latest movies that have been
  // added to the server and then fetch them in.
  static Widget buildRecentlyAdded() {
    return SizedBox(
      height: 250,
      width: double.maxFinite,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 60,
            ),
          ],
        ),
        child: FutureBuilder(
          future: movieHelper.getMoviesBy(5, 1, 'date_added', 'desc', 0),
          builder: (context, snapshot) {
            if (snapshot.data == null)
              return HomeMethods.errorOrLoading('');
            else
              return PageView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => MovieDetailsRouteUI(
                            snapshot.data[index],
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.maxFinite,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image:
                                  Image.network(snapshot.data[index].coverImage)
                                      .image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          child: Stack(
                            children: <Widget>[
                              Icon(Icons.bookmark,
                                  color: DarkTheme.homeColor, size: 70),
                              Positioned(
                                top: 11,
                                left: 25,
                                child: Icon(Icons.star,
                                    color: Color(0xfff1c40f), size: 20),
                              ),
                              Positioned(
                                top: 33,
                                left: 25,
                                child: Text(
                                  snapshot.data[index].rating.toString(),
                                  style: TextStyle(
                                      color: DarkTheme.whiteTitleColor3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              height: 100,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black54, Colors.transparent],
                                ),
                              ),
                              child: Text(
                                snapshot.data[index].titleLong,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: DarkTheme.whiteTitleColor3,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
          },
        ),
      ),
    );
  }
}
