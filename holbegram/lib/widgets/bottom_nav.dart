import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

import '../screens/pages/feed.dart';
import '../screens/pages/search.dart';
import '../screens/pages/add_image.dart';
import '../screens/pages/favorite.dart';
import '../screens/pages/profile_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    Provider.of<UserProvider>(context, listen: false).refreshUser();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [Feed(), Search(), AddImage(), Favorite(), Profile()],
      ),

      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });

          _pageController.jumpToPage(index);
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),

          BottomNavyBarItem(
            icon: Icon(Icons.search),
            title: Text(
              'Search',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),

          BottomNavyBarItem(
            icon: Icon(Icons.add_box),
            title: Text(
              'Add',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),

          BottomNavyBarItem(
            icon: Icon(Icons.favorite),
            title: Text(
              'Favorite',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),

          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 25, fontFamily: 'Billabong'),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
