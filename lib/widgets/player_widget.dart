import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'dart:async';
import 'package:musik/model/song.dart';
import 'package:musik/services/apple_music_service.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({Key? key, required this.song}) : super(key: key);
  final Song song;

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final musicStore = AppleMusicStore.instance;
  bool _isPlaying = false;
  StreamSubscription? _playerSubscription;
  final _player = FlutterSoundPlayer();

  String _startText = '00:00';
  String _endText = '00:00';
  var sliderCurrentPosition = const Duration(seconds: 0);
  var maxDuration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _initPlayer();
    initializeDateFormatting();
  }

  void _initPlayer() {
    _player.openPlayer();
    _player.setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  void _startPlayer(String uri) async {
    debugPrint('🎵 start player: $uri');

    await _player.startPlayer(fromURI: uri);
    await _player.setVolume(1.0);

    try {
      _playerSubscription = _player.onProgress!.listen((e) async {
        sliderCurrentPosition = e.position;
        maxDuration = e.duration;

        final remaining = e.duration - e.position;

        DateTime date = DateTime.fromMillisecondsSinceEpoch(
            e.position.inMilliseconds,
            isUtc: true);

        DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
            remaining.inMilliseconds,
            isUtc: true);

        String startText = DateFormat('mm:ss', 'en_GB').format(date);
        String endText = DateFormat('mm:ss', 'en_GB').format(endDate);

        if (mounted) {
          setState(() {
            _startText = startText;
            _endText = endText;
            sliderCurrentPosition = sliderCurrentPosition;
            maxDuration = maxDuration;
          });
        }
      });
    } catch (err) {
      setState(() => _isPlaying = false);
    }
  }

  _pausePlayer() async {
    _player.pausePlayer().then((value) {
      debugPrint('pausePlayer');
      setState(() => _isPlaying = false);
    });
  }

  _resumePlayer() async {
    _player.resumePlayer().then((_) {
      debugPrint('resumePlayer');
      setState(() => _isPlaying = true);
    });
  }

  _seekToPlayer(int milliSecs) async {
    final secs = Platform.isIOS ? milliSecs / 1000 : milliSecs;

    if (_playerSubscription == null) {
      return;
    }

    _player.seekToPlayer(Duration(seconds: secs.toInt()));
  }

  @override
  void dispose() async {
    super.dispose();
    await _player.stopPlayer();
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: ListView(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.grey,
                      )),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0, // has the effect of softening the shadow
                        spreadRadius: 1.0, // has the effect of extending the shadow
                        offset: Offset(
                          0.5, // horizontal, move right 10
                          0.5, // vertical, move down 10
                        ),
                      )
                    ]),
                    margin: const EdgeInsets.only(top: 16, right: 16.0, left: 16.0),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(
                          widget.song.artworkUrl(512),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 32, left: 16, right: 16),
                    width: MediaQuery.of(context).size.width,
                    child: CupertinoSlider(
                        value: sliderCurrentPosition.inSeconds.toDouble(),
                        min: 0.0,
                        max: maxDuration.inSeconds.toDouble(),
                        onChangeEnd: (x) {},
                        onChangeStart: (x) {},
                        onChanged: (double value) async {
                          await _seekToPlayer(value.toInt());
                        },
                        divisions: maxDuration.inSeconds)),
                Container(
                  margin: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _startText,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        _endText,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 6.0),
                  child: Text(
                    widget.song.name,
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
                  child: Text(
                      "${widget.song.artistName} - ${widget.song.albumName}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1),
                )
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 56.0,
                  height: 56.0,
                  child: ClipOval(
                    child: TextButton(
                      onPressed: () {
                        if (_isPlaying) {
                          _pausePlayer();
                        } else {
                          if (_playerSubscription == null) {
                            setState(() => _isPlaying = true);
                            Timer(const Duration(milliseconds: 200), () {
                              _startPlayer(widget.song.previewUrl);
                            });
                          } else {
                            _resumePlayer();
                          }
                        }
                      },
                      child: Image(
                        image: _isPlaying
                            ? const AssetImage('res/icons/ic_pause.png')
                            : const AssetImage('res/icons/ic_play.png'),
                      ),
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ],
        ));
  }
}
