import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Movies.dart';
import '../Themes/AppThemes.dart';
import '../Routes/MovieDetailsRoute.dart';

class DetailsMethods {
  // static public method to generate and build
  // widgets with customized UI for (Genres).
  // called in '_buildCenterContent' function in
  // 'MovieDetailsRoute.dart'.
  static List<Widget> getGenres(List<String> gens) {
    List<Widget> temWidget = [];
    for (var g in gens) {
      temWidget.add(
        Container(
          margin: const EdgeInsets.only(right: 4, top: 4),
          padding: const EdgeInsets.only(top: 3, bottom: 3, left: 6, right: 6),
          decoration: BoxDecoration(
            color: Color(0xff384657),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            g.toString(),
            style: TextStyle(
              color: Color(0xffc7c7c7),
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    return temWidget;
  }

  // static public method to generate and build
  // widget with customized UI for ErrorLoading.
  // function called in 'MovieDetailsRoute.dart'.
  static Widget errorOrLoading() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SpinKitThreeBounce(
              size: 25,
              color: DarkTheme.errorProgressColor,
            ),
          ),
        ],
      ),
    );
  }

  // this is public method called in 'MovieDetailsRoute.dart'
  // for fetching the movie cast respectivly
  static Widget castListContent(MovieDetails movieDetails) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              '\nMovie Cast',
              style: TextStyle(
                color: DarkTheme.whiteTitleColor3,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Column(
            children: _getCastChildren(movieDetails),
          )
        ],
      ),
    );
  }

  // private static method to get the cast in a specific movie
  // and then place, order and style them into ListTile
  // then put them all together as List of widgets as
  // defined here 'List<Widget>'.
  static List<Widget> _getCastChildren(MovieDetails movieDetails) {
    List<Widget> childs = [];
    for (var c in movieDetails.cast) {
      ListTile listTile = ListTile(
        contentPadding: const EdgeInsets.only(left: 5),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: _getImage(c.urlSmallImage),
          radius: 25,
        ),
        title: Text(
          c.name,
          style: TextStyle(
            color: DarkTheme.whiteTitleColor2,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          c.characterName,
          style: TextStyle(
            color: DarkTheme.whiteTitleColor0,
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
      childs.add(listTile);
    }
    return childs;
  }

  // check if the given image url is null or not
  static dynamic _getImage(String url) {
    return (!(url == null))
        ? Image.network(url, fit: BoxFit.contain).image
        : null;
  }

  // public method called in 'MovieDetailsRoute.dart'
  // for getting, validating and place youTube url
  static void playYoutubeVideo(String youtubeVideoID) {
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: 'AIzaSyAVojmfPd6C49AhXet_MEVGXrHzmm8xT-I',
      videoUrl: 'https://www.youtube.com/watch?v=' + youtubeVideoID,
    );
  }

  static Widget getScreenShotsAndStyle(AsyncSnapshot<dynamic> snapshot) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 10),
            child: Text(
              'Quick Shots',
              style: TextStyle(
                color: DarkTheme.whiteTitleColor3,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            width: double.maxFinite,
            child: PageView.builder(
              itemCount: snapshot.data.movieScreenshots.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      snapshot.data.movieScreenshots[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  static Widget buildMovies(List<Movie> movies) {
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

  // --------------------------------------------------------
  // Puplic static method used to read/write data represented
  // as favorite movies

  static void setFavorite(String key, bool isFavorited) async {
    final perfs = await SharedPreferences.getInstance();
    perfs.setBool(key, isFavorited);
  }

  static Future<bool> getFavorite(String key) async {
    final perfs = await SharedPreferences.getInstance();
    bool data = perfs.getBool(key) ?? false;
    return data;
  }

  static void removeFavorite(String key) async {
    final perfs = await SharedPreferences.getInstance();
    perfs.remove(key);
  }
}
