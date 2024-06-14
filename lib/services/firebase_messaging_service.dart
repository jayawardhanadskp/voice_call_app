import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  late FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal() {
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      _messaging = FirebaseMessaging.instance;
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print('Error retrieving FCM token: $e');
      return null;
    }
  }

  Future<void> saveToken(String userId) async {
    String? token = await getToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).set({'token': token}, SetOptions(merge: true));
    }
  }

  Future<String?> getTokenForUser(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.get('token');
    }
    return null;
  }
  Future<void> requestPermission() async {
    try {
      await _messaging.requestPermission();
    } catch (e) {
      print('Error requesting FCM permission: $e');
    }
  }

  Future<void> sendMessage(String token, String message) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/voice-call-app-2d2bf/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=decb96f444f4e3dd056c1911f452e77e356ab323',
        },
        body: jsonEncode(
          <String, dynamic>{
            'to': token,
            'notification': {
              'title': 'Incoming Call',
              'body': message,
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'message': message,
              'actions': [
                {
                  'action': 'ANSWER_CALL',
                  'title': 'Answer',
                },
                {
                  'action': 'REJECT_CALL',
                  'title': 'Reject',
                }
              ]
            }
          },
        ),
      );
      print('send message successful');
    } catch (e) {
      print('Error sending FCM message: $e');
    }
  }


}
