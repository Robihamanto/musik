import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musik/scenes/browse_scene.dart';
import 'package:musik/widgets/search_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Musik',
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

  int _currentIndex = 0;
  final List<Widget> _children = [];
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _initChildren();
  }

  _initChildren() {
    _pageController = PageController(initialPage: _currentIndex);
    _children.add(const BrowseWidget());
    _children.add(const SearchWidget());;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0x9C343F55),
        unselectedItemColor: CupertinoColors.systemGrey4,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
          )
        ],
        onTap: _moveToTab,
      )
    );
  }

  void _moveToTab(int index) {
    setState(() => _currentIndex = index);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_pageController!.hasClients) _pageController!.jumpToPage(index);
    });
  }


}
