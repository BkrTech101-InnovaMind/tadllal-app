import 'package:flutter/material.dart';
import 'package:tedllal/model/api_models/notifications.dart';
import 'package:tedllal/pages/notification_page/widgets/all_notifications.dart';
import 'package:tedllal/pages/notification_page/widgets/unread_notifications.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/widgets/pages_back_button.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isActive = true;
  late PageController _pageController;
  int currentPage = 0;
  List<Widget> _nestedPages = [];

  @override
  void initState() {
    _nestedPages = [
      const AllNotification(),
      const UnReadNotification(),
    ];
    _pageController = PageController(initialPage: currentPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            buildToggleButtons(),
            buildPageView(),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F4F8),
        border: Border(bottom: BorderSide(color: Colors.black38)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const PagesBackButton(),
          MaterialButton(
            height: 30.0,
            minWidth: 50.0,
            color: const Color(0xFFF5F4F8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            textColor: const Color(0xFF1F4C6B),
            padding: const EdgeInsets.all(16),
            onPressed: () {
              _getNotifications().then(
                (value) => const ScaffoldMessenger(
                  child: SnackBar(
                    content: Text("تم التحديد بنجاح"),
                  ),
                ),
              );
            },
            splashColor: const Color(0xFFF5F4F8),
            child: const Text(
              'تحديد الكل ك مقروء',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToggleButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                  _isActive = false;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                foregroundColor:
                    _isActive ? const Color(0xFF234F68) : Colors.white,
                backgroundColor:
                    _isActive ? Colors.grey[200] : const Color(0xFF8BC83F),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              child: const Text(
                'غير مقروء',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(
                  () {
                    _pageController.animateToPage(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                    _isActive = true;
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                foregroundColor:
                    !_isActive ? const Color(0xFF234F68) : Colors.white,
                backgroundColor:
                    !_isActive ? Colors.grey[200] : const Color(0xFF8BC83F),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
              ),
              child: const Text(
                'الجميع',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageView() {
    return Expanded(
      child: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            currentPage = page;
            currentPage == 0 ? _isActive = true : _isActive = false;
          });
        },
        reverse: true,
        children: _nestedPages,
      ),
    );
  }

  Future<List<Notifications>> _getNotifications() async {
    var date = await DioApi().get("/notifications/markAllAsRead");
    List<dynamic> notificationsData = date.data["data"];
    return notificationsData
        .map((data) => Notifications.fromJson(data))
        .toList();
  }
}
