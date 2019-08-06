// Movie Class
class Movie {
  final String id;
  final String titleLong;
  final String rating;
  final List<String> genres;
  final String fullDescription;
  final String coverImage;
  final String year;
  final String mpaRating;
  final String language;
  final String youTubeTrailerCode;
  Movie(
    this.id,
    this.titleLong,
    this.rating,
    this.year, [
    this.fullDescription,
    this.coverImage,
    this.genres,
    this.mpaRating,
    this.language,
    this.youTubeTrailerCode,
  ]);
}

// MovieDetails Class
class MovieDetails {
  final List<Cast> cast;
  final List<String> movieScreenshots;
  MovieDetails(this.cast, [this.movieScreenshots]);
}

// Cast Class
class Cast {
  final String name;
  final String characterName;
  final String urlSmallImage;
  Cast(
    this.name,
    this.characterName,
    this.urlSmallImage,
  );
}
