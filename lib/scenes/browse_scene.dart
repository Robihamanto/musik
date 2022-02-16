import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:musik/model/main.dart';
import 'package:musik/services/apple_music_service.dart';
import 'package:musik/widgets/album_widget.dart';
import 'package:musik/widgets/carousel_album.dart';
import 'package:musik/widgets/carousel_song_widget.dart';

class BrowseWidget extends StatefulWidget{

  const BrowseWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BrowseWidgetState();
  }
}

class _BrowseWidgetState extends State<BrowseWidget> with AutomaticKeepAliveClientMixin  {

  @override
  bool get wantKeepAlive => true;

  final musicStore = AppleMusicStore.instance;
  late Future<Main> _main;

  @override
  void initState() {
    super.initState();
    _main = musicStore.fetchBrowseHome();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Browse'),
        ),
        child: FutureBuilder<Main>(
          future: _main,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final albumChart = snapshot.data!.chart.albumChart;

              final List<Widget> list = [];

              list.add(const Padding(
                padding: EdgeInsets.only(top: 16),
              ));
              list.add(CarouselAlbum(
                title: albumChart.name,
                albums: albumChart.albums,
              ));

              final songChart = snapshot.data!.chart.songChart;

              list.add(const Padding(
                padding: EdgeInsets.only(top: 16),
              ));
              list.add(CarouselSongWidget(
                title: songChart.name,
                songs: songChart.songs, cta: '',
              ));

              for (var f in snapshot.data!.albums) {
                list.add(const Padding(
                  padding: EdgeInsets.only(top: 16),
                ));
                list.add(CarouselSongWidget(
                  title: f.name,
                  songs: f.songs,
                  cta: 'See Album',
                  onCtaTapped: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(CupertinoPageRoute(
                        builder: (context) => AlbumWidget(
                          albumId: f.id,
                          albumName: f.name,
                        )));
                  },
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
        ));
  }
}
