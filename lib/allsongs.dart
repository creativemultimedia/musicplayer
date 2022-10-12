import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:musicplayer/config.dart';
import 'package:musicplayer/playpage.dart';
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
          List<SongModel> list=snapshot.data as List<SongModel>;
          return Column(
            children: [
              ListTile(
                leading: IconButton(onPressed: () async {
                  int random=Random().nextInt(list.length-0)+0;
                  config.play.value=true;
                  config.index.value=random;
                  await config.player.play(DeviceFileSource("${config.allsongs[config.index.value].data}"));
                },icon: Icon(Icons.shuffle),),
                title: Text("Shuffle All(${list.length})"),),
              Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index)  {
                      SongModel songModel=list[index];
                      print(songModel);
                      return ValueListenableBuilder(valueListenable: config.play, builder: (context, value1, child) {
                        return ListTile(
                          onTap: () async {
                            config.play.value=true;
                            if(index!=config.index.value)
                            {
                              config.index.value=index;
                            }
                            else
                            {
                              print("hi");
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return playpage(list);
                              },));
                            }
                            print(config.index.value);
                            if(config.player.state==PlayerState.playing)
                            {
                              await config.player.stop();
                              await config.player.play(DeviceFileSource("${config.allsongs[config.index.value].data}"));
                            }
                            else{
                              await config.player.play(DeviceFileSource("${config.allsongs[config.index.value].data}"));
                            }
                          },
                          trailing:  ValueListenableBuilder(valueListenable: config.index,builder: (context, value2, child) {
                            return value1==true && index==value2?Image.network("https://i.pinimg.com/originals/cb/17/b8/cb17b80a942d7c317a35ff1324fae12f.gif",height: 50,width: 50,fit: BoxFit.fitHeight):
                            Text("");
                          },),
                          leading:FutureBuilder(
                            builder: (context, snapshot) {
                              if(snapshot.hasData)
                                {
                                  return snapshot.data!;
                                }
                              else
                                {
                                  return Icon(Icons.music_note);
                                }
                            },
                            future: config.getmediaImage(index),
                          ),
                          title: Text("${songModel.title}"),
                          subtitle: Text("${songModel.artist}"),
                        );
                      },);
                    }, separatorBuilder: (context, index) {
                  return Divider();
                }, itemCount: list.length),
              )
            ],
          );
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
