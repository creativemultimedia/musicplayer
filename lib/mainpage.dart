import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:musicplayer/albumsongs.dart';
import 'package:musicplayer/artistsongs.dart';
import 'allsongs.dart';
import 'config.dart';
class mainpage extends StatefulWidget {
  const mainpage({Key? key}) : super(key: key);

  @override
  State<mainpage> createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> with TickerProviderStateMixin{
  TabController? tabController;
  @override
  void initState() {
    tabController=TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App"),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: "All"),
            Tab(text: "Artists"),
            Tab(text: "Album"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          allsongs(),
          albumsongs(),
          artistsongs(),
        ],
      ),
      bottomNavigationBar:ListTile(
        leading: Icon(Icons.music_note),
        trailing: config.play?
        IconButton(
          onPressed: () async {
            await config.player.pause();
            setState(() {
              config.play=!config.play;
            });
          },
          icon: Icon(Icons.pause),
        ):
        IconButton(
          onPressed: () async {
            await config.player.play(DeviceFileSource("${config.allsongs[0].data}"));
            setState(() {
              config.play=!config.play;
            });
          },
          icon: Icon(Icons.play_arrow),
        ),
        title: config.allsongs.length>0?SizedBox(height: 50,child: Marquee(text: "${config.allsongs[0].title}",blankSpace: 30,),):Text("Test"),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    config.player.stop().then((value) {});
  }
}
