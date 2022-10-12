import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'config.dart';

class playpage extends StatefulWidget {
  List<SongModel> songs;
  playpage(this.songs);
  @override
  State<playpage> createState() => _playpageState();
}

class _playpageState extends State<playpage> {
  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0)
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    else
      return "$twoDigitMinutes:$twoDigitSeconds";
  }
  TextEditingController t1=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ValueListenableBuilder(
                builder: (context, value, child) {
                  return FutureBuilder(
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
                    future: config.getmediaImage(value),
                  );
                },
                valueListenable: config.index,
              )
          ),
          Expanded(
              child: Column(
            children: [
              ListTile(
                title: SizedBox(
                  height: 50,
                  child: Marquee(
                    text: "${widget.songs[config.index.value].title}",
                    blankSpace: 30,
                  ),
                ),
                subtitle: Text("${widget.songs[config.index.value].artist}"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
                  IconButton(onPressed: () {
                    showModalBottomSheet(context: context, builder: (context) {
                      return Column(
                        children: [
                          ListTile(onTap:(){
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                title: TextField(controller: t1,),
                                actions: [
                                  TextButton(onPressed: () async {
                                    await config.audioQuery.createPlaylist(t1.text);
                                    Navigator.pop(context);
                                  }, child: Text("Create")),
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text("Cancel")),
                                ],
                              );
                            },);
                          },title: Text("Create New Playlist"),),
                          Expanded(child: FutureBuilder(builder: (context, snapshot) {
                            if(snapshot.connectionState==ConnectionState.done)
                            {
                              List<PlaylistModel> playlist=snapshot.data as List<PlaylistModel>;
                              return ListView.builder(shrinkWrap: true,itemBuilder: (context, index) {
                                return ListTile(onTap:() async {
                                  await config.audioQuery.addToPlaylist(playlist[index].id,widget.songs[config.index.value].id);
                                  Navigator.pop(context);
                                },
                                  title: Text("${playlist[index].getMap['name']}"),
                                  subtitle: Text("${playlist[index].getMap['num_of_songs']}"),
                                );
                              },itemCount:playlist.length,);
                            }
                            else
                            {
                              return Container();
                            }
                          },future: config.getplaylists(),))
                        ],
                      );
                    },);
                  }, icon: Icon(Icons.add)),
                ],
              ),
              //slider
              Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder(valueListenable: config.songtime, builder: (context, value, child) {
                      return Row(
                        children: [
                          Text(printDuration(Duration(milliseconds: value.toInt()))),
                          Slider(
                            value:value,
                            onChanged: (val)  async {
                              config.songtime.value=val;
                              await config.player.seek(Duration(milliseconds: val.toInt()));
                            },
                            min: 0,
                            max: widget.songs[config.index.value].duration!.toDouble(),
                          )
                        ],
                      );
                    },),
                  ),
                  Text(printDuration(Duration(milliseconds: widget.songs[config.index.value].duration!))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () async {
                    await config.player.setReleaseMode(ReleaseMode.loop);
                  }, icon: Icon(Icons.loop)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.skip_previous)),
                  ValueListenableBuilder(valueListenable: config.play, builder: (context, value, child) {
                    return value?
                    IconButton(onPressed: () async{
                      await config.player.pause();
                      config.play.value=!config.play.value;
                    }, icon: Icon(Icons.pause)):
                    IconButton(onPressed: () async {
                      await config.player.play(DeviceFileSource("${widget.songs[config.index.value].data}"));
                      config.play.value=!config.play.value;
                    },
                        icon: Icon(Icons.play_arrow));
                  },),
                  IconButton(onPressed: () {

                  }, icon: Icon(Icons.skip_next)),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    config.player.dispose().then((value) {
      config.play.value=false;
    });
  }

  @override
  void initState() {
      config.player.onPositionChanged.listen((Duration  p){
        config.songtime.value=p.inMilliseconds.toDouble();
      print('Current position: ${config.songtime.value}');
    });
  }
}
