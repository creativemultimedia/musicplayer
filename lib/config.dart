import 'package:flutter/cupertino.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
class config
{
  static ValueNotifier<int> index=ValueNotifier(0);
  // static int index=0;
  static AudioPlayer player = AudioPlayer();
  // static bool play=false;
  static ValueNotifier<bool> play=ValueNotifier(false);
  static ValueNotifier<double> songtime=ValueNotifier(0);
  static OnAudioQuery audioQuery = OnAudioQuery();
  static List<SongModel> allsongs=[];
  static List<ArtistModel> artistsongs=[];
  static List<PlaylistModel> playlists=[];
  static List<AlbumModel> alumsongs=[];

  static getallsongs() async {
    allsongs = await audioQuery.querySongs();
    return allsongs;
  }
  static getartistsongs() async {
    artistsongs = await audioQuery.queryArtists();
    return artistsongs;
  }
  static getalbumsongs() async {
    alumsongs = await audioQuery.queryAlbums();
    return alumsongs;
  }
  static getplaylists() async {
    playlists = await audioQuery.queryPlaylists();
    print(playlists);
    return playlists;
  }
}