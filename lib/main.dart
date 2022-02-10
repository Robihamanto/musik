import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musik/scenes/browse_scene.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
        primaryColor: Colors.blue,
      ),
      home: MainScene(),
    );
  }
}
class MainScene extends StatefulWidget {
  const MainScene({Key? key}) : super(key: key);

  @override
  _MainSceneState createState() => _MainSceneState();
}

class _MainSceneState extends State<MainScene> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar:  CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search')
        ],
      ),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (context) => const BrowseWidget(),
              );
            case 1:
              return CupertinoTabView(
                builder: (context) => const BrowseWidget(),
              );
            default:
              return Container();
          }
        },
    );
  }
}
