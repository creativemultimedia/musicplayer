import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class albumsongs extends StatefulWidget {
  const albumsongs({Key? key}) : super(key: key);

  @override
  State<albumsongs> createState() => _albumsongsState();
}

class _albumsongsState extends State<albumsongs> {
  OnAudioQuery _audioQuery = OnAudioQuery();
  getalbumsongs() async {
    List<AlbumModel> something = await _audioQuery.queryAlbums();
    print(something);
    return something;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done)
        {
          List<AlbumModel> list=snapshot.data as List<AlbumModel>;
          return ListView.separated(itemBuilder: (context, index) {
            AlbumModel albumModel=list[index];
            return ListTile(title: Text("${albumModel.album}"),);
          }, separatorBuilder: (context, index) {
            return Divider();
          }, itemCount: list.length);
        }
        else
        {
          return Center(child: CircularProgressIndicator(),);
        }
      },
      future: getalbumsongs(),
    );
  }
}
