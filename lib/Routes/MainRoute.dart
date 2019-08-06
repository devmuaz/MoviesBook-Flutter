import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Utils/Movies.dart';
import '../Utils/MovieHelper.dart';
import '../Static/MainMethods.dart';
import '../Themes/AppThemes.dart';

class MainRouteUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainRouteUIState();
}

class MainRouteUIState extends State<MainRouteUI> {
  // For handling the Scaffold State through its key
  // Note: (used here to open the Drawer Widget by a specific button).
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

  // MovieHelper: handling http requests and json parse operations.
  MovieHelper movieHelper = MovieHelper();

  // Incremented by one each time you load more movies
  // 10 movies per page.
  int page = 1;

  // Needed variables
  bool isLoaded = true;
  int pageIndex = 0;
  double scrollPosition = 0;
  String searchText = '';

  // List of movies that will be loaded
  // this list will hold all the movies when
  // (initLoading, loadingMore, Serach...etc)
  List<Movie> movieList = [];

  // ScrollController to controll the listView scrolling
  // and other listener methods.
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    HomeMethods.scrollController = ScrollController();
    HomeMethods.scrollController.addListener(
      () {
        if (HomeMethods.scrollController.offset >=
                HomeMethods.scrollController.position.maxScrollExtent &&
            !HomeMethods.scrollController.position.outOfRange) {
          _loadMoreMovies();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      backgroundColor: DarkTheme.homeColor,
      appBar: AppBar(
        backgroundColor: DarkTheme.appBarColor,
        title: Text('Movies Book'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldStateKey.currentState.openDrawer(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert, color: DarkTheme.whiteIconColor),
            onPressed: () {},
          )
        ],
      ),
      body: _buildMainViews(),
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  // Function returns the whole pages we need to show
  Widget _buildMainViews() {
    return Container(
      child: PageView(
        controller: pageController,
        onPageChanged: (index) => setState(() => pageIndex = index),
        children: <Widget>[
          _buildHomePage(),
          _buildBrowsePage(),
          _buildSearchPage(),
          _buildSettingsPage(),
        ],
      ),
    );
  }

  // Function returns the first page [Home Page]
  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HomeMethods.buildRecentlyAdded(),
          // [Most Seen] Section
          HomeMethods.topTitleBar('Most Seen', 'See More'),
          SizedBox(
            height: 250,
            child:
                HomeMethods.buildMoviesOn(10, 1, 'download_count', 'desc', 0),
          ),
          // [Most Popular] Section
          HomeMethods.topTitleBar('Most Popular', 'See More'),
          SizedBox(
            height: 250,
            child: HomeMethods.buildMoviesOn(10, 1, 'like_count', 'desc', 0),
          ),
          // [Top Rated] Section
          HomeMethods.topTitleBar('Top Rated', 'See More'),
          SizedBox(
            height: 250,
            child: HomeMethods.buildMoviesOn(10, 1, 'rating', 'desc', 0),
          ),
          // [This Year] Section
          HomeMethods.topTitleBar('This Year', 'See More'),
          SizedBox(
            height: 250,
            child: HomeMethods.buildMoviesOn(10, 1, 'year', 'desc', 0),
          ),
          // [Recently] Section
          HomeMethods.topTitleBar('Recently', 'See More'),
          SizedBox(
            height: 250,
            child: HomeMethods.buildMoviesOn(10, 1, 'date_added', 'desc', 0),
          ),
        ],
      ),
    );
  }

  // Function returns the second page [Browsing Movies Page]
  Widget _buildBrowsePage() {
    return FutureBuilder(
      future: movieHelper.getMoviesBy(10, 1, 'year', 'desc', 0),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return HomeMethods.errorOrLoading('Loading');
        } else {
          // [isLoaded] is boolean for loading once in the list (10 movies)
          // then will no longer be called.. update movies will depends
          // on the loadMoreMovies method to get more movies and append
          // them in the global movieList
          if (isLoaded) {
            this.movieList = snapshot.data;
            isLoaded = false;
            return HomeMethods.bodyContent(context, this.movieList);
          } else {
            return HomeMethods.bodyContent(context, this.movieList);
          }
        }
      },
    );
  }

  // Function returns the search page [Search Page]
  Widget _buildSearchPage() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon:
                  Icon(Icons.search, color: DarkTheme.whiteIconColor, size: 25),
              border: DarkTheme.primaryBorder,
              enabledBorder: DarkTheme.primaryBorder,
              focusedBorder: DarkTheme.borderFocus,
              fillColor: DarkTheme.textFieldBackColor,
              filled: true,
              contentPadding: const EdgeInsets.only(
                  left: 10, top: 13, bottom: 13, right: 10),
              hintText: 'Type Movie Title, Actor\'s Name, ...',
              hintStyle: TextStyle(color: DarkTheme.whiteTitleColor1),
            ),
            style: TextStyle(color: DarkTheme.whiteTitleColor3),
            onSubmitted: (typedValue) {
              setState(() {
                searchText = typedValue;
              });
            },
          ),
        ),
        _buildfetchedNovies(),
      ],
    );
  }

  // This functions is responsible of fetching the movies we want
  // to search about..and then called back in the [Search Page Function]
  Widget _buildfetchedNovies() {
    if (searchText.isNotEmpty) {
      return FutureBuilder(
        future: movieHelper.getSearchedMoviesBy(searchText),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return HomeMethods.errorOrLoading('');
          } else {
            return Expanded(
              child: HomeMethods.bodyContent(context, snapshot.data),
            );
          }
        },
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: <Widget>[
            Icon(Icons.movie, color: DarkTheme.whiteTitleColor0, size: 100),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'Movie Search, Type & Hit',
                style: TextStyle(
                    color: DarkTheme.whiteTitleColor0,
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
              ),
            )
          ],
        ),
      );
    }
  }

  // Function returns the settings page [Settings Page]
  Widget _buildSettingsPage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.report, color: DarkTheme.whiteTitleColor0, size: 100),
          Text(
            'No Current Settings in\nthis beta version.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: DarkTheme.whiteTitleColor0,
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  // Functions returns the widget that resposible to build the drawer
  // which then called in the body..
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: DarkTheme.homeColor,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 250,
              child: Container(
                color: DarkTheme.movieCardColor,
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      height: double.maxFinite,
                      child: Image(
                        image: AssetImage('assets/images/movie_poster.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: double.maxFinite,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            height: 80,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black54, Colors.transparent],
                              ),
                            ),
                            child: Text(
                              'Movies Book',
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
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: DarkTheme.whiteIconColor),
              title: Text(
                'Favorites',
                style:
                    TextStyle(color: DarkTheme.whiteTitleColor3, fontSize: 16),
              ),
              onTap: () {},
            ),
            ListTile(
              leading:
                  Icon(Icons.movie_creation, color: DarkTheme.whiteIconColor),
              title: Text(
                'Discover More',
                style:
                    TextStyle(color: DarkTheme.whiteTitleColor3, fontSize: 16),
              ),
              onTap: () {},
            ),
            Divider(color: DarkTheme.whiteTitleColor1),
            ListTile(
              leading: Icon(Icons.report, color: DarkTheme.whiteIconColor),
              title: Text(
                'Report Problem',
                style:
                    TextStyle(color: DarkTheme.whiteTitleColor3, fontSize: 16),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person, color: DarkTheme.whiteIconColor),
              title: Text(
                'Contact Us',
                style:
                    TextStyle(color: DarkTheme.whiteTitleColor3, fontSize: 16),
              ),
              onTap: () {},
            ),
            ListTile(
              leading:
                  Icon(Icons.contact_phone, color: DarkTheme.whiteIconColor),
              title: Text(
                'About',
                style:
                    TextStyle(color: DarkTheme.whiteTitleColor3, fontSize: 16),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  //********************************************************** [Needed Methods]

  // this function is called when loading more movies
  // or in other meaning.. this is called when we reach
  // almost the end of the listView that contains the
  // movies.. to load more movies and so on..
  // [Asyncronized function]
  void _loadMoreMovies() async {
    setState(() {
      scrollPosition = HomeMethods.scrollController.position.maxScrollExtent;
      page++;
      Fluttertoast.showToast(
        msg: 'Loading More Movies...',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color(0xcb000000),
      );
    });

    movieList.addAll(
      await movieHelper.getMoviesBy(10, page, 'year', 'desc', 0).then(
        (onValue) {
          HomeMethods.scrollController.jumpTo(scrollPosition + 100);
          Fluttertoast.showToast(
            msg: 'Loaded',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Color(0xcb000000),
          );
          return onValue;
        },
      ),
    );
  }

  // Private function for changing the pages each time
  // you scroll or change the current page
  void _changePage(int changedIndex) {
    setState(() {
      pageIndex = changedIndex;
      pageController.jumpToPage(changedIndex);
    });
  }

  // Function returns the widget of the [Navigation Bottom Bar]
  // used a third-party package represented by 'BubbleBottomBar'
  Widget _buildNavigationBar() {
    return BubbleBottomBar(
      backgroundColor: DarkTheme.navigationBarColor,
      opacity: 1,
      currentIndex: pageIndex,
      onTap: (value) => _changePage(value),
      items: <BubbleBottomBarItem>[
        BubbleBottomBarItem(
          backgroundColor: DarkTheme.activeButtonColor,
          icon: Icon(Icons.movie, color: DarkTheme.whiteIconColor),
          activeIcon: Icon(Icons.movie, color: DarkTheme.appBarColor),
          title: Text('Home', style: TextStyle(color: DarkTheme.appBarColor)),
        ),
        BubbleBottomBarItem(
          backgroundColor: DarkTheme.activeButtonColor,
          icon: Icon(Icons.local_library, color: DarkTheme.whiteIconColor),
          activeIcon: Icon(Icons.local_library, color: DarkTheme.appBarColor),
          title: Text('Browse', style: TextStyle(color: DarkTheme.appBarColor)),
        ),
        BubbleBottomBarItem(
          backgroundColor: DarkTheme.activeButtonColor,
          icon: Icon(Icons.search, color: DarkTheme.whiteIconColor),
          activeIcon: Icon(Icons.search, color: DarkTheme.appBarColor),
          title: Text('Search', style: TextStyle(color: DarkTheme.appBarColor)),
        ),
        BubbleBottomBarItem(
          backgroundColor: DarkTheme.activeButtonColor,
          icon: Icon(Icons.settings, color: DarkTheme.whiteIconColor),
          activeIcon: Icon(Icons.settings, color: DarkTheme.appBarColor),
          title:
              Text('Settings', style: TextStyle(color: DarkTheme.appBarColor)),
        ),
      ],
    );
  }
}
