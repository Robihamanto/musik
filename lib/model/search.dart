import 'album.dart';
import 'song.dart';
import 'artist.dart';

class Search {
  final String term;
  final List<Album> albums;
  final List<Song> songs;
  final List<Artist> artists;

  Search({required this.albums, required this.songs, required this.artists, required this.term});

  int get totalCount => albums.length + songs.length + artists.length;
  bool get isEmpty => totalCount == 0;
}