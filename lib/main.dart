import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


import 'firebase_options.dart';
import 'model/user_model.dart';
import 'screens/call_screen.dart';
import 'screens/ongoing_call_screen.dart';
import 'screens/user_selection_screen.dart';
import 'services/agora_service.dart';
import 'services/firebase_messaging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  

  // Request permission on iOS
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.getInitialMessage();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Get the token
  String? token = await messaging.getToken();
  print("FCM Token: $token");

  final agoraService = AgoraService();
  await agoraService.initializeAgora();


  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title ?? ''),
              content: Text(notification.body ?? ''),
              actions: [
                TextButton(
                  onPressed: () {
                    _handleAction('ANSWER_CALL', message.data);
                  },
                  child: Text('Answer'),
                ),
                TextButton(
                  onPressed: () {
                    _handleAction('REJECT_CALL', message.data);
                  },
                  child: Text('Reject'),
                ),
              ],
            );
          },
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleAction(message.data['action'], message.data);
    });
  }

  void _handleAction(String? action, Map<String, dynamic> data) {
    if (action == 'ANSWER_CALL') {
      // Parse user data from the notification payload
      UserModel user = UserModel.fromJson(jsonDecode(data['user']));
      String token = data['token'];

      // Navigate to CallScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(user: user, token: token),
        ),
      );
    } else if (action == 'REJECT_CALL') {
      // Handle call rejection
      print('Call rejected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Call App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(),
    );
  }
}
