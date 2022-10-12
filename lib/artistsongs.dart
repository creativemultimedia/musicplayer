import 'package:flutter/material.dart';
import 'package:musicplayer/artistpage.dart';
import 'package:musicplayer/config.dart';
import 'package:on_audio_query/on_audio_query.dart';

class artistsongs extends StatefulWidget {
  const artistsongs({Key? key}) : super(key: key);

  @override
  State<artistsongs> createState() => _artistsongsState();
}

class _artistsongsState extends State<artistsongs> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done)
        {
          List<ArtistModel> list=snapshot.data as List<ArtistModel>;
          return ListView.separated(itemBuilder: (context, index) {
            ArtistModel artistModel=list[index];
            return ListTile(
              onTap: () {
                // config.page.value="artist";
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return artistpage(artistModel);
                },));
              },
              title: Text("${artistModel.artist}"),
              subtitle: Text("${artistModel.numberOfAlbums} album | ${artistModel.numberOfTracks} song"),
            );
          }, separatorBuilder: (context, index) {
            return Divider();
          }, itemCount: list.length);
        }
        else
        {
          return Center(child: CircularProgressIndicator(),);
        }
      },
      future: config.getartistsongs(),
    );
  }
}
