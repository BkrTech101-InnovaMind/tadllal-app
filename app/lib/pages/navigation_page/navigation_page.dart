import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tedllal/pages/favorites_page/favorites_page.dart';
import 'package:tedllal/pages/home_page/home_page.dart';
import 'package:tedllal/pages/search_page/search_page.dart';
import 'package:tedllal/pages/user_page/profile_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final PageController pageController = PageController();
  final List<Widget> pages = [
    const HomePage(),
    const SearchPage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  final List<FlashyTabBarItem> items = [
    FlashyTabBarItem(
      icon: SvgPicture.asset('assets/icons/home-icon.svg'),
      title: const Text("الرئيسية", style: TextStyle(fontSize: 17)),
    ),
    FlashyTabBarItem(
      icon: SvgPicture.asset('assets/icons/search-icon.svg'),
      title: const Text("البحث", style: TextStyle(fontSize: 17)),
    ),
    FlashyTabBarItem(
      icon: SvgPicture.asset(
        'assets/icons/favorites-icon.svg',
      ),
      title: const Text("ألمفضلة", style: TextStyle(fontSize: 17)),
    ),
    FlashyTabBarItem(
      icon: SvgPicture.asset('assets/icons/user-icon.svg'),
      title: const Text("الحساب", style: TextStyle(fontSize: 17)),
    ),
  ];

  void onItemSelected(int index) {
    setState(() {
      currentIndex = index;
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        itemBuilder: (context, index) {
          return pages[index];
        },
        onPageChanged: (index) {
          setState(
            () {
              currentIndex = index;
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
        child: FlashyTabBar(
          items: items,
          onItemSelected: onItemSelected,
          selectedIndex: currentIndex,
          animationCurve: Curves.easeInOutBack,
          animationDuration: const Duration(
            milliseconds: 400,
          ),
          showElevation: true,
          shadows: [BoxShadow(color: Colors.black.withOpacity(0.5))],
          height: 55,
          iconSize: 20,
        ),
      ),
    );
  }
}
