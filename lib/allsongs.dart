import 'package:flutter/material.dart';
import 'package:musicplayer/config.dart';
import 'package:on_audio_query/on_audio_query.dart';

class allsongs extends StatefulWidget {

  @override
  State<allsongs> createState() => _allsongsState();
}
class _allsongsState extends State<allsongs> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done)
        {
          List list=snapshot.data as List;
          return ListView.separated(itemBuilder: (context, index) {
            SongModel songModel=list[index];
            print(songModel);
            return ListTile(
              title: Text("${songModel.title}"),
              subtitle: Text("${songModel.artist}"),
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
      future: config.getallsongs(),
    );
  }
}
