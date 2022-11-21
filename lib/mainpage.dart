import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:musicplayer/albumsongs.dart';
import 'package:musicplayer/artistpage.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light
          //color set to transperent or set your own color
        )
    );
    tabController=TabController(length: 3, vsync: this);
    print(config.page.value);
  }

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.blue,
        systemNavigationBarColor: Colors.transparent
        // ...
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
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
          artistsongs(),
          albumsongs(),
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
          valueListenable: config.index,
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
              await config.player.play(DeviceFileSource("${config.allsongs[config.index.value].data}"));
              config.play.value=!config.play.value;
            },
            icon: Icon(Icons.play_arrow),
          );
        },valueListenable: config.play,),
        title: config.allsongs.length>0?ValueListenableBuilder(valueListenable: config.index, builder: (context, value, child) {
          return SizedBox(height: 50,child: Marquee(text: "${config.allsongs[value].title}",blankSpace: 30,),);
        },):Text("Test"),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    config.player.dispose().then((value) {});
  }
}
