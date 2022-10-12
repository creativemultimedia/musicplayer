import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:musicplayer/playpage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'config.dart';
class artistpage extends StatefulWidget {
  ArtistModel artistModel;
  artistpage(this.artistModel);

  @override
  State<artistpage> createState() => _artistpageState();
}

class _artistpageState extends State<artistpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: Column(
        children: [
          Text("${widget.artistModel.artist}"),
          Expanded(child: FutureBuilder(builder: (context, snapshot) {
            List<SongModel> list=snapshot.data as List<SongModel>;
            return ListView.builder(
              itemBuilder: (context, index)  {
                SongModel songModel=list[index];
                print(songModel);
                return ValueListenableBuilder(valueListenable: config.play, builder: (context, value1, child) {
                  return ListTile(
                    onTap: () async {
                      config.play.value=true;
                      if(index!=config.artistindex.value)
                      {
                        config.artistindex.value=index;
                      }
                      else
                      {
                        print("hi");
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return playpage(list);
                        },));
                      }
                      print(config.artistindex.value);
                      if(config.player.state==PlayerState.playing)
                      {
                        await config.player.stop();
                        await config.player.play(DeviceFileSource("${config.songsbyartist.value[config.artistindex.value].data}"));
                      }
                      else{
                        await config.player.play(DeviceFileSource("${config.songsbyartist.value[config.artistindex.value].data}"));
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
              },itemCount: list.length,);
          },future: config.getallsongbyartist(widget.artistModel.id),))
        ],
      ),
      bottomNavigationBar:ListTile(
        leading: ValueListenableBuilder(
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
          valueListenable: config.artistindex,
        ),
        trailing: ValueListenableBuilder(builder: (context, value, child) {
          return value?
          IconButton(
            onPressed: () async {
              await config.player.pause();
              config.play.value=!config.play.value;
            },
            icon: Icon(Icons.pause),
          ):
          IconButton(
            onPressed: () async {
              await config.player.play(DeviceFileSource("${config.songsbyartist.value[config.artistindex.value].data}"));
              config.play.value=!config.play.value;
            },
            icon: Icon(Icons.play_arrow),
          );
        },valueListenable: config.play,),
        title: ValueListenableBuilder(
          valueListenable: config.songsbyartist,
          builder: (context, value1, child) {
            return value1.length>=0?
            ValueListenableBuilder(valueListenable: config.artistindex, builder: (context, value, child) {
              return SizedBox(height: 50,child: Marquee(text: "${value1[value].title}",blankSpace: 30,),);
            },):Text("Test");
          },
        ),
      ),
    );
  }
}
