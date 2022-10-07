import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'config.dart';

class playpage extends StatefulWidget {
  const playpage({Key? key}) : super(key: key);

  @override
  State<playpage> createState() => _playpageState();
}

class _playpageState extends State<playpage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Container(color: Colors.amberAccent,)),
          Expanded(child: Column(
            children: [
                ListTile(title: SizedBox(height: 50,child: Marquee(text: "${config.allsongs[config.index.value].title}",blankSpace: 30,),), subtitle: Text("${config.allsongs[config.index.value].artist}"),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {
                  }, icon: Icon(Icons.favorite_border)),
                  IconButton(onPressed: () {

                  }, icon: Icon(Icons.add)),

                ],
              ),
              Slider(value: 5, onChanged: (value) {
              },min: 1,max: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {

                  }, icon: Icon(Icons.loop)),
                  IconButton(
                  onPressed: ()  {}, icon: Icon(Icons.skip_previous)),
                  config.play.value?
                  IconButton(onPressed: () async{
                    await config.player.pause();
                    config.play.value=!config.play.value;
                  }, icon: Icon(Icons.pause)):
                  IconButton(onPressed: () async {
                    await config.player.play(DeviceFileSource("${config.allsongs[config.index.value].data}"));
                    config.play.value=!config.play.value;
                  },
                      icon: Icon(Icons.play_arrow)),
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
    config.player.dispose().then((value) {});
  }
  @override
  void initState() {
    if(config.player.state==PlayerState.playing)
      {
        config.player.stop().then((value) {});
      }

  //   config.player.onPositionChanged.listen((Duration  p){
  //   print('Current position: $p');
  // });
  }
}
