import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tedllal/model/api_models/notifications.dart';
import 'package:tedllal/pages/real_estate_details_page/real_estate_details_page.dart';
import 'package:tedllal/services/api/dio_api.dart';
import 'package:tedllal/widgets/loading_ui/loader2.dart';

class UnReadNotification extends StatefulWidget {
  const UnReadNotification({super.key});

  @override
  State<UnReadNotification> createState() => _UnReadNotificationState();
}

class _UnReadNotificationState extends State<UnReadNotification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: FutureBuilder<List<Notifications>>(
        future: _getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ColorLoader2();
          } else if (snapshot.hasData) {
            List<Notifications> notifications = snapshot.data!;
            return notifications.isEmpty
                ? const Center(
                    child: Text(
                      'لا يوجد',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                  )
                : ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const Divider(
                      thickness: 2,
                    ),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _buildNotificationItem(notification, context);
                    },
                  );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }

  Widget _buildNotificationItem(Notifications notification, context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RealEstateDetailsPage(
                realEstate: notification.realEstate,
              ),
            ),
          );
          setState(() {
            _setNotifications(notification.id);
          });
        },
        title: Text(
          notification.realEstate.attributes!.name!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          notification.realEstate.attributes!.description!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            notification.realEstate.attributes!.photo!,
          ),
        ),
      ),
    );
  }

  Future<List<Notifications>> _getNotifications() async {
    var date = await DioApi().get("/notifications/unread");
    List<dynamic> notificationsData = date.data["data"];
    return notificationsData
        .map((data) => Notifications.fromJson(data))
        .toList();
  }

  Future<List<Notifications>> _setNotifications(String id) async {
    var date = await DioApi().get("/notifications/markAsRead/$id");
    List<dynamic> notificationsData = date.data["data"];
    return notificationsData
        .map((data) => Notifications.fromJson(data))
        .toList();
  }
}
