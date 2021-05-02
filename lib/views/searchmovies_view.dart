import 'package:flutter/material.dart';
import 'package:search_movies_list/controllers/search_movies.dart';
import 'package:search_movies_list/models/search_model.dart';

class SearchListExample extends StatefulWidget {
  @override
  _SearchListExampleState createState() => new _SearchListExampleState();
}

class _SearchListExampleState extends State<SearchListExample> {
  Widget appBarTitle = new Text(
    "Search Example",
    style: new TextStyle(color: Colors.black),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.black,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _list = [];
  bool _isSearching;
  String _searchText = "";
  List searchresult = [];
  List movies_detaille = [];

  _SearchListExampleState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    values();
  }

  void values({String text_movies}) {
    //_list = [];
    // list add the result of search evry moment user search
    if (text_movies != null) {
      _list.add(text_movies);
      setState(() {
        _list = _list;
      });
    }
    /*
    _list.add(text_movies);
    _list.add("Indian rupee");
    _list.add("United States dollar");
    _list.add("Australian dollar");
    _list.add("Euro");
    _list.add("British pound");
    _list.add("Yemeni rial");
    _list.add("Japanese yen");
    _list.add("Hong Kong dollar");
    */
  }

  Future seachMovies(String movie) async {
    movies_detaille.clear();
    Results res = await SearchMovies().SearchMovie(movie);
    if (res != null) {
      movies_detaille.add(res.title ?? 'no title');
      movies_detaille.add(res.overview ?? 'no no overview');
      movies_detaille.add(res.backdropPath ?? 'no picture');
      print(res.voteAverage ?? 'err');
      return movies_detaille;
    } else {
      movies_detaille.add('le filme ne pas existe');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        appBar: buildAppBar(context),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        searchresult.length != 0 || _controller.text.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchresult.length,

                                /// list of search
                                itemBuilder: (BuildContext context, int index) {
                                  String listData = searchresult[index];
                                  return Card(
                                      child: ListTile(
                                    leading: Icon(Icons.update),
                                    title: Text(listData.toString()),
                                    onTap: () {
                                      /// go into Filme description
                                      print(
                                          'index of filme from (searchresult) : $index');
                                      //SheetBottom();
                                    },
                                  ));
                                },
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _list.length,

                                /// list of propositions
                                itemBuilder: (BuildContext context, int index) {
                                  String listData = _list[index];
                                  return Card(
                                    child: ListTile(
                                      leading: Icon(Icons.update),
                                      title: Text(listData.toString()),
                                      onTap: () {
                                        /// go into Filme description
                                        print(
                                            'index of filme from (_list) : $index');
                                        //SheetBottom();
                                      },
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: icon,
            onPressed: () {
              setState(() {
                if (this.icon.icon == Icons.search) {
                  this.icon = Icon(
                    Icons.close,
                    color: Colors.black,
                  );
                  this.appBarTitle = TextField(
                    controller: _controller,
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.black),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.black)),
                    onChanged: searchOperation,
                    onSubmitted: (_) async {
                      /// here u can add function
                      print('onSubmitted');
                      var list_inf = await seachMovies(_controller.text);
                      print('List contain information $list_inf');
                      values(text_movies: _controller.text.toString());
                      SheetBottom(
                        title: list_inf[0].toString(),
                        overviw: list_inf[1].toString(),
                        image: list_inf[2].toString(),
                      );
                      //rintText(list_inf);
                    },
                  );
                  _handleSearchStart();

                  /// function to add search
                  print('text need to search : ${_controller.text}');
                } else {
                  print('text need to search : ${_controller.text}');
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  SheetBottom({String title, image, String overviw}) {
    return Scaffold.of(context).showBottomSheet<void>((BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * .8,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title ?? 'No title',
                style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'RobotoMono'),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  overviw ?? 'No title',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                    'https://image.tmdb.org/t/p/original$image' ?? ''),
              ),
              RaisedButton(
                color: Colors.teal,
                child: Container(
                  width: double.infinity,
                  child: Center(child: Text('Close ')),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = Icon(
        Icons.search,
        color: Colors.black,
      );
      this.appBarTitle = Text(
        "Search Sample",
        style: TextStyle(color: Colors.black),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void printText(String text) {
    setState(() {
      text = text;
    });
    print('---- print Text : $text ------');
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          // print('----- print data : $data --------');
          searchresult.add(data);
        }
      }
    }
  }
}
