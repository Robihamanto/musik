import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:musik/model/artist.dart';
import 'package:musik/services/apple_music_service.dart';
import 'package:musik/widgets/carousel_album.dart';

import 'carousel_song_widget.dart';

class ArtistWidget extends StatefulWidget {
  final String artistId;
  final String artistName;

  ArtistWidget({required this.artistId, required this.artistName});

  @override
  State<StatefulWidget> createState() {
    return ArtistWidgetState();
  }
}

class ArtistWidgetState extends State<ArtistWidget> {
  Future<Artist>? _artist;
  final _musicStore = AppleMusicStore.instance;

  @override
  void initState() {
    super.initState();
    _artist = _musicStore.fetchArtistById(widget.artistId);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.artistName),
        ),
        child: FutureBuilder<Artist>(
            future: _artist,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final artist = snapshot.data;
                final List<Widget> list = [];

                if (artist!.albums.length > 0) {
                  list.add(Padding(
                    padding: EdgeInsets.only(top: 16),
                  ));
                  list.add(CarouselAlbum(
                    title: 'Top Albums',
                    albums: artist.albums,
                  ));
                }

                if (artist.songs.length > 0) {
                  list.add(Padding(
                    padding: EdgeInsets.only(top: 16),
                  ));
                  list.add(CarouselSongWidget(
                    title: 'Top Songs',
                    songs: artist.songs, cta: '',
                  ));
                }

                return ListView(
                  children: list,
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
