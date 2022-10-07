import 'package:flutter/material.dart';
import 'allsongs.dart';

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
          allsongs(),
          allsongs(),
        ],
      ),
    );
  }
}
