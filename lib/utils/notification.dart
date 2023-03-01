// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationServices {
//   final FlutterLocalNotificationsPlugin _flutterNotif =
//       FlutterLocalNotificationsPlugin();
//   final AndroidInitializationSettings _androidInitializationSettings =
//       const AndroidInitializationSettings('ic_launcher');
//   void initializeNotification() async {
//     InitializationSettings initS =
//         InitializationSettings(android: _androidInitializationSettings);
//     await _flutterNotif.initialize(initS);
//   }

//   sendNotification() async {
//     AndroidNotificationDetails andDetail = const AndroidNotificationDetails(
//         'channelId', 'channelName', 'channelDescription',
//         importance: Importance.max, priority: Priority.max);
//     NotificationDetails notifDetails = NotificationDetails(android: andDetail);

//     await _flutterNotif.show(
//         0, '', 'Thank you for sharing food with me', notifDetails);
//   }
// }
