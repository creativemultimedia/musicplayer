import 'package:on_audio_query/on_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
class config
{
  static AudioPlayer player = AudioPlayer();
  static bool play=false;
  static OnAudioQuery _audioQuery = OnAudioQuery();
  static List<SongModel> allsongs=[];
  static List<ArtistModel> artistsongs=[];
  static List<AlbumModel> alumsongs=[];

  static getallsongs() async {
    allsongs = await _audioQuery.querySongs();
    return allsongs;
  }
  static getartistsongs() async {
    artistsongs = await _audioQuery.queryArtists();
    return artistsongs;
  }
  static getalbumsongs() async {
    alumsongs = await _audioQuery.queryAlbums();
    return alumsongs;
  }
}