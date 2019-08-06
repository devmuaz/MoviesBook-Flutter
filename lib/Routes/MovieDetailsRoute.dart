import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Static/DetailsMethods.dart';
import '../Utils/MovieHelper.dart';
import '../Utils/Movies.dart';
import '../Themes/AppThemes.dart';

class MovieDetailsRouteUI extends StatefulWidget {
  final Movie movie;
  MovieDetailsRouteUI(this.movie);
  @override
  State<StatefulWidget> createState() => StateMovieDetailsRouteUI(this.movie);
}

class StateMovieDetailsRouteUI extends State<MovieDetailsRouteUI> {
  bool isMovieDetailsLoaded = false;
  final Movie movie;
  MovieDetails movieDetails;
  MovieHelper movieHelper = MovieHelper();
  StateMovieDetailsRouteUI(this.movie);

  bool isBookMarked = false;
  @override
  void initState() {
    super.initState();
    getFavoriteAndUpdate();
  }

  void getFavoriteAndUpdate() async {
    await DetailsMethods.getFavorite(this.movie.id).then(
      (onValue) => setState(
        () => isBookMarked = onValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkTheme.homeColor,
      body: buildBody(),
    );
  }

  // [buildBody] to build a listView with all the page
  // components
  Widget buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildTopImage(),
            _buildCenterContent(),
            _buildCastMovie(),
            _buildScreenshotMovie(),
            _buildSeggustedMovies(),
            _buildYoutubeContent(),
          ],
        ),
      ),
    );
  }

  // [private function] called in 'buildBody' function
  // this will build the top large image of the movie
  // with its name combined together in stack widget
  Widget _buildTopImage() {
    return SizedBox(
      width: double.maxFinite,
      height: 500,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            child: Image.network(
              this.movie.coverImage,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: 200,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                height: 200,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 30, left: 10, right: 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      this.movie.titleLong,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // private function called in 'buildBody' function
  // this will build the center content which includes
  // (geners, imdb rating, favorite, movie year, full description)
  Widget _buildCenterContent() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Color(0xfff9ca24),
                  ),
                ),
                child: Text(
                  'IMDB  ' + this.movie.rating,
                  style: TextStyle(color: Color(0xfff9ca24), fontSize: 20),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Color(0xfff9ca24),
                  ),
                ),
                child: Text(
                  this.movie.year,
                  style: TextStyle(color: Color(0xfff6e58d), fontSize: 20),
                ),
              ),
              _buildMPARating(),
              _buildFavoriteButton(),
            ],
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: DetailsMethods.getGenres(this.movie.genres),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(
              'What this movie about?',
              style: TextStyle(
                color: DarkTheme.whiteTitleColor3,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              this.movie.fullDescription,
              style: TextStyle(
                color: DarkTheme.whiteTitleColor1,
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  // private function called in or belong to
  // '_buildCenterContent' function to get or
  // build (MPA Rating widget) which then called
  // in 'buildBody' method.
  Widget _buildMPARating() {
    return (this.movie.mpaRating.isNotEmpty)
        ? Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            decoration: BoxDecoration(
              color: DarkTheme.backColorMPA,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Text(
              this.movie.mpaRating,
              style: TextStyle(
                color: DarkTheme.textColorMPA,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Container();
  }

  // private function called in or belong to
  // '_buildCenterContent' function to build
  // (add to favorite BUTTON) and then called
  // in '_buildCenterContent' above.
  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: () {
        setState(() => isBookMarked = !isBookMarked);
        if (isBookMarked) {
          DetailsMethods.setFavorite(this.movie.id, true);
          Fluttertoast.showToast(
            msg: 'Movie Added to Favorites',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xcb000000),
          );
        } else {
          DetailsMethods.removeFavorite(this.movie.id);
          Fluttertoast.showToast(
            msg: 'Movie Removed from Favorites',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xcb000000),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        child: (isBookMarked)
            ? Icon(
                Icons.favorite,
                size: 33,
                color: Colors.red[400],
              )
            : Icon(
                Icons.favorite_border,
                size: 33,
                color: Colors.white54,
              ),
      ),
    );
  }

  // private function to build and get the cast
  // and order them into widgets and then called
  // in '_buildCenterContent' function.
  Widget _buildCastMovie() {
    return FutureBuilder(
      future: movieHelper.getMovieDetails(this.movie.id),
      builder: (context, snapshot) {
        if (snapshot.data == null)
          return DetailsMethods.errorOrLoading();
        else {
          this.movieDetails = snapshot.data;
          return DetailsMethods.castListContent(this.movieDetails);
        }
      },
    );
  }

  // private function to get youTube url about the
  // opened or selected movie and build suitable
  // widget to be managed by the user.
  // then called in '_buildCenterContent' function.
  Widget _buildYoutubeContent() {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Trailer',
              style: TextStyle(
                color: DarkTheme.whiteTitleColor3,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                DetailsMethods.playYoutubeVideo(this.movie.youTubeTrailerCode),
            child: SizedBox(
              height: 200,
              width: double.maxFinite,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: DarkTheme.movieCardColor,
                ),
                child: Icon(
                  Icons.play_circle_filled,
                  color: DarkTheme.homeColor,
                  size: 80,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Function return some of the movie screenshots
  Widget _buildScreenshotMovie() {
    return FutureBuilder(
      future: movieHelper.getMovieDetails(this.movie.id),
      builder: (context, snapshot) {
        return (snapshot.data == null)
            ? DetailsMethods.errorOrLoading()
            : DetailsMethods.getScreenShotsAndStyle(snapshot);
      },
    );
  }

  // Function returns the suggested movies
  Widget _buildSeggustedMovies() {
    return FutureBuilder(
      future: movieHelper.getSuggestedMoviesBy(this.movie.id),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return DetailsMethods.errorOrLoading();
        } else {
          return Container(
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Text(
                    'Suggested',
                    style: TextStyle(
                      color: DarkTheme.whiteTitleColor3,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: DetailsMethods.buildMovies(snapshot.data),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
