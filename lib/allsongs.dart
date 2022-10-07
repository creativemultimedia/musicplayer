import 'package:audioplayers/audioplayers.dart';
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
          return ListView.separated(
              itemBuilder: (context, index) {
              SongModel songModel=list[index];
              print(songModel);
            return ListTile(
              onTap: () async {
                  config.index.value=index;
                  config.playlist.value[index]=true;
                  print(config.playlist.value);
                  await config.player.play(DeviceFileSource("${config.allsongs[config.index.value].data}"));
              },
              trailing: Image.network("https://i.pinimg.com/originals/cb/17/b8/cb17b80a942d7c317a35ff1324fae12f.gif",height: 50,width: 50,fit: BoxFit.fitHeight),
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
