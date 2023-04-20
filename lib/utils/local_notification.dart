// import 'package:flutter/material.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// NotificationDetails get _noSound {
//   final androidChannelSpecifics = AndroidNotificationDetails(
//     'silent channel id',
//     'silent channel name',
//     playSound: false,
//   );
//   // final iOSChannelSpecifics = IOSNotificationDetails(presentSound: false);

//   return NotificationDetails(android: androidChannelSpecifics);
// }

// Future showSilentNotification(
//     FlutterLocalNotificationsPlugin notifications, {
//       required String title,
//       required String body,
//       int id = 0,
//     }) =>
//     _showNotification(notifications,
//         title: title, body: body, id: id, type: _noSound);

// NotificationDetails get _ongoing {
//   final androidChannelSpecifics = AndroidNotificationDetails(
//     'your channel id',
//     'your channel name',
//     importance: Importance.max,
//     priority: Priority.high,
//     ongoing: false,
//     autoCancel: true,
//   );
//   // final iOSChannelSpecifics = IOSNotificationDetails();
//   return NotificationDetails(android: androidChannelSpecifics,);
// }

// Future showOngoingNotification(
//   FlutterLocalNotificationsPlugin notifications, {
//   required String title,
//   required String body,
//   int id = 0,
// }) { 
//   debugPrint("nice to meet ");
//   return _showNotification(notifications,
//         title: title, body: body, id: id, type: _ongoing);
//         }
  

// Future _showNotification(
//   FlutterLocalNotificationsPlugin notifications, {
//   required String title,
//   required String body,
//   required NotificationDetails type,
//   int id = 0,
// }) {
//    debugPrint("nice to meet ");
//   return  notifications.show(id, title, body, type);
// }
   
