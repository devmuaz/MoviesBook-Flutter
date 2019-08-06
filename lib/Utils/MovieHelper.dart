import 'dart:core';
import './Movies.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieHelper {
  // public futured method for getting movies as list by specifying
  // the parameters:
  //  {
  //    limit       : number of movies per page max=50
  //    page        : each page can get 0-50 movie
  //    sortBy      : sorting the movies by (title, year, date_added, rating, ...)
  //    orderby     : ordering the movies by (asc, desc)
  //    ratingRange : get movies according to its imdb rating (0-9)
  //  }
  // once the data (json data) received..will be decoded and list them
  // then return the listed movies to the function.
  Future<List<Movie>> getMoviesBy(
    int limit,
    int page,
    String sortBy,
    String orderBy,
    int ratingRange,
  ) async {
    List<Movie> movies = [];
    var response = await http.get(
      'https://yts.lt/api/v2/list_movies.json?' +
          'limit=$limit&' +
          'page=$page&' +
          'sort_by=$sortBy&' +
          'order_by=$orderBy&' +
          'minimum_rating=$ratingRange',
    );

    var jsonData = json.decode(response.body);

    for (var mov in jsonData['data']['movies']) {
      List<String> generes = [];
      for (String gen in mov['genres']) generes.add(gen);

      Movie movie = Movie(
        mov['id'].toString(),
        mov['title_english'].toString(),
        mov['rating'].toString(),
        mov['year'].toString(),
        mov['description_full'].toString(),
        mov['large_cover_image'].toString(),
        generes,
        mov['mpa_rating'].toString(),
        mov['language'].toString(),
        mov['yt_trailer_code'].toString(),
      );
      movies.add(movie);
    }
    return movies;
  }

  // public futured method used for fetching further information about
  // specific movie by the required parameter:
  //  {
  //    id : is the id number of the movie
  //  }
  // then all decoded information from json data collected into
  // MovieDetails instance that will be return to the function itself.
  Future<MovieDetails> getMovieDetails(String id) async {
    var response = await http.get(
      'https://yts.lt/api/v2/movie_details.json?' +
          'movie_id=$id&' +
          'with_cast=true&with_images=true',
    );
    var jsonData = json.decode(response.body);

    List<Cast> castList = [];
    for (var cast in jsonData['data']['movie']['cast']) {
      Cast cst =
          Cast(cast['name'], cast['character_name'], cast['url_small_image']);
      castList.add(cst);
    }

    List<String> movieScreenshots = [
      jsonData['data']['movie']['medium_screenshot_image1'],
      jsonData['data']['movie']['medium_screenshot_image2'],
      jsonData['data']['movie']['medium_screenshot_image3'],
    ];

    MovieDetails movieDetails = MovieDetails(castList, movieScreenshots);

    return movieDetails;
  }

  // Public futured method for fetching suggested movies according
  // to the given movie id in the function which then will return
  // a list of suggested movies
  // Parameters: {movieID: the id of the movie you want to get to}
  Future<List<Movie>> getSuggestedMoviesBy(String movieID) async {
    List<Movie> movies = [];
    var response = await http.get(
      'https://yts.lt/api/v2/movie_suggestions.json?movie_id=$movieID',
    );
    var jsonData = json.decode(response.body);
    for (var mov in jsonData['data']['movies']) {
      List<String> generes = [];
      for (String gen in mov['genres']) generes.add(gen);

      Movie movie = Movie(
        mov['id'].toString(),
        mov['title_english'].toString(),
        mov['rating'].toString(),
        mov['year'].toString(),
        mov['description_full'].toString(),
        mov['medium_cover_image'].toString(),
        generes,
        mov['mpa_rating'].toString(),
        mov['language'].toString(),
        mov['yt_trailer_code'].toString(),
      );
      movies.add(movie);
    }
    return movies;
  }

  // Public futured method used to search about a specific movies
  // starting by giving the title of the movie or something
  // similar, then get the specific result as a list of movies
  Future<List<Movie>> getSearchedMoviesBy(String movieTitle) async {
    List<Movie> movies = [];
    var response = await http.get(
      'https://yts.lt/api/v2/list_movies.json?query_term=$movieTitle',
    );
    var jsonData = json.decode(response.body);
    for (var mov in jsonData['data']['movies']) {
      List<String> generes = [];
      for (String gen in mov['genres']) generes.add(gen);

      Movie movie = Movie(
        mov['id'].toString(),
        mov['title_english'].toString(),
        mov['rating'].toString(),
        mov['year'].toString(),
        mov['description_full'].toString(),
        mov['medium_cover_image'].toString(),
        generes,
        mov['mpa_rating'].toString(),
        mov['language'].toString(),
        mov['yt_trailer_code'].toString(),
      );
      movies.add(movie);
    }
    return movies;
  }
}
