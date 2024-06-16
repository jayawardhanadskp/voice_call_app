import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../screens/incomming_call_screen.dart';

class NotificationService{
  const NotificationService._();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
          'high_importance_channel',
          'high_important_name',
          description: 'description',
          importance: Importance.max,
          playSound: true,
      );

  static NotificationDetails _notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        icon: '@mipmap/ic_launcher'
      )
    );
  }

  static Future<void> initializeNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getInitialMessage();

    await _notificationsPlugin.initialize(
      const InitializationSettings(
        android: androidInitializationSettings,
        iOS: DarwinInitializationSettings(),
      ),
    );
    FirebaseMessaging.onMessage.listen(onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      final context = navigatorKey.currentState?.context;
      if (context != null) {
        onMessageOpenedApp(context, message);
      }
    });
  }

  static void onMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    AppleNotification? appleNotification = message.notification?.apple;

    if (notification == null) return;

    if (androidNotification != null || appleNotification != null) {
      _notificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      _notificationDetails(),
      );
    }
  }

  static void onMessageOpenedApp(BuildContext context, RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    AppleNotification? appleNotification = message.notification?.apple;

    if (notification == null) return;

    if (androidNotification != null || appleNotification != null) {

      String callingUserName = message.data['callingUserName'] ?? 'Unknown';
      String? channelName = 'channelName';

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            IncommingCallScreen(
                callingUserName: callingUserName,
              channelName: channelName,
            )),
      );
    }
  }

}