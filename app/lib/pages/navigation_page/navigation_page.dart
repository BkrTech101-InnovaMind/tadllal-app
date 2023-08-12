import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tadllal/pages/home_page/home_page.dart';

class NavigationPage extends StatefulHookConsumerWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  final PageController pageController = PageController();
  final List<Widget> pages = [
    const HomePage(),
    const HomePage(),
    const HomePage(),
    const HomePage(),
  ];

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            pageController.animateToPage(
              index,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home-icon.svg',
            ),
            activeIcon: Column(children: [
              SvgPicture.asset(
                'assets/icons/home-icon.svg',
              ),
              SvgPicture.asset(
                'assets/icons/active-rout-icon.svg',
              ),
            ]),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/search-icon.svg',
            ),
            activeIcon: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/search-icon.svg',
                ),
                SvgPicture.asset(
                  'assets/icons/active-rout-icon.svg',
                ),
              ],
            ),
            label: 'البحث',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/favorites-icon.svg',
            ),
            label: 'المفضلة',
            activeIcon: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/favorites-icon.svg',
                ),
                SvgPicture.asset(
                  'assets/icons/active-rout-icon.svg',
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/user-icon.svg',
            ),
            label: 'المستخدم',
            activeIcon: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/user-icon.svg',
                ),
                SvgPicture.asset(
                  'assets/icons/active-rout-icon.svg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
