
import 'package:flutter/material.dart';
import 'package:voice_call_app/services/agora_service.dart';

import 'services/firebase_helper.dart';
import 'services/notification_service.dart';


late final Widget screen;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseHelper.setupFirebase();
  await NotificationService.initializeNotification();

  final agoraService = AgoraService();
  await agoraService.initializeAgora();


  screen = FirebaseHelper.homeScreen;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: screen,
    );
  }
}
