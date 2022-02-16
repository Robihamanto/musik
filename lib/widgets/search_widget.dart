import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:musik/model/artist.dart';
import 'package:musik/model/search.dart';
import 'package:musik/services/apple_music_service.dart';
import 'package:musik/widgets/carousel_album.dart';
import 'carousel_song_widget.dart';
import 'cupertino_search_bar.dart';
import 'divider_widget.dart';
import 'artist_widget.dart';

class SearchWidget extends StatefulWidget {

  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SearchWidgetState();
  }
}

class SearchWidgetState extends State<SearchWidget>
    with SingleTickerProviderStateMixin {
  final _searchTextController = TextEditingController();
  final _searchFocusNode = FocusNode();
  Animation<double>? _animation;
  late AnimationController _animationController;
  Future<Search>? _search;
  AppleMusicStore musicStore = AppleMusicStore.instance;
  String? _searchTextInProgress;

  @override
  initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
    _searchFocusNode.addListener(() {
      if (!_animationController.isAnimating) {
        _animationController.forward();
      }
    });

    _searchTextController.addListener(_performSearch);
  }

  _performSearch() {
    final text = _searchTextController.text;
    if (_search != null && text == _searchTextInProgress) {
      return;
    }

    if (text.isEmpty) {
      setState(() {
        _search = null;
        _searchTextInProgress = null;
      });
      return;
    }

    setState(() {
      _search = musicStore.search(text);
      _searchTextInProgress = text;
    });
  }

  _cancelSearch() {
    _searchTextController.clear();
    _searchFocusNode.unfocus();
    _animationController.reverse();
    setState(() {
      _search = null;
      _searchTextInProgress = null;
    });
  }

  _clearSearch() {
    _searchTextController.clear();
    setState(() {
      _search = null;
      _searchTextInProgress = null;
    });
  }

  @override
  dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: IOSSearchBar(
        controller: _searchTextController,
        focusNode: _searchFocusNode,
        animation: _animation!,
        onCancel: _cancelSearch,
        onClear: _clearSearch,
      )),
      child: GestureDetector(
        onTapUp: (TapUpDetails _) {
          _searchFocusNode.unfocus();
          if (_searchTextController.text == '') {
            _animationController.reverse();
          }
        },
        child: _search != null
            ? FutureBuilder<Search>(
                future: _search,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState != ConnectionState.waiting) {
                    final searchResult = snapshot.data;
                    final songs = searchResult!.songs;
                    final albums = searchResult.albums;
                    List<Artist> artists = searchResult.artists;
                    if (artists.length > 3) {
                      artists = artists.sublist(0, 3);
                    }

                    final List<Widget> list = [];

                    if (artists.isNotEmpty) {
                      list.add(Padding(
                          padding:
                              const EdgeInsets.only(top: 16, left: 20, right: 20),
                          child: Text(
                            'Artists',
                            style: Theme.of(context).textTheme.subtitle2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )));
                      list.add(
                        const DividerWidget(
                          margin: EdgeInsets.only(
                              top: 8.0, left: 20.0, right: 20.0),
                        ),
                      );

                      for (var a in artists) {
                        list.add(
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 20, right: 20, bottom: 16),
                              child: Material(
                                color: Colors.white,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(CupertinoPageRoute(
                                              builder: (context) =>
                                                  ArtistWidget(
                                                      artistId: a.id,
                                                      artistName: a.name)));
                                    },
                                    child: Text(
                                      a.name,
                                      style: Theme.of(context).textTheme.subtitle1,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )),
                              )),
                        );
                        list.add(
                          const DividerWidget(
                            margin: EdgeInsets.only(
                                top: 0.0, left: 36.0, right: 20.0),
                          ),
                        );
                      }
                    }

                    if (albums.isNotEmpty) {
                      list.add(const Padding(
                        padding: EdgeInsets.only(top: 16),
                      ));
                      list.add(CarouselAlbum(
                        title: 'Albums',
                        albums: albums,
                      ));
                    }

                    if (songs.isNotEmpty) {
                      list.add(const Padding(
                        padding: EdgeInsets.only(top: 16),
                      ));
                      list.add(CarouselSongWidget(
                        title: 'Songs',
                        songs: songs, cta: '',
                      ));
                    }

                    return ListView(
                      children: list,
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              )
            : const Center(
                child: Text('Type on search bar to begin')
        ), // Add search body here
      ),
    );
  }
}
