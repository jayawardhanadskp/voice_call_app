
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../model/user.dart';
import '../screens/home.dart';
import '../screens/sign_up.dart';

class FirebaseHelper {
  const FirebaseHelper._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> setupFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );
  }


  static Future<bool> saveUser({
    required email,
    required password,
    required name,
  }) async {
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return false;
      }

      var userRef = _db.collection('users').doc(credential.user!.uid);

      final now = DateTime.now();
      final String createdAt = '${now.year}-${now.month}-${now.day}';

      final String? token = await FirebaseMessaging.instance.getToken();

      final userModel = UserModel(
        uid: credential.user!.uid,
        name: name,
        platform: Platform.operatingSystem,
        token: token!,
        createdAt: createdAt,
      );

      await userRef.set(userModel.toJson());

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> get buildViews
    => _db.collection('users').snapshots();

  static Widget get homeScreen {
    if (_auth.currentUser != null) {
      return HomeScreen();
    }
    return const SignUp();
  }

  static Future<void> testHealth() async {
    HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('checkHealth');

    final response = await callable.call();

    if (response.data != null) {
      print(response.data);
    }
  }

  static Future<void> _onBackgroundMessage(RemoteMessage message) async{
    await setupFirebase();
    print('recive a notification ${message.notification}');
  }

  static Future<String?> uploadImage(File file) async {
    final storageRef = FirebaseStorage.instance.ref();
    Reference? imageRef = storageRef.child('images/token_image.jpg');

    try{
      await imageRef.putFile(file);
      return await imageRef.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> sendNotification({
    required title,
    required body,
    required token,
    image,
    channelName,
    callerName,
  }) async {
    HttpsCallable callable =
    FirebaseFunctions.instance.httpsCallable('sendNotification');

    try {
      final response = await callable.call(
          <String, dynamic>{
            'title': title,
            'body': body,
            'image': image,
            'token': token,
            'channelName': channelName,
            'callerName': callerName,
          });

      print('result is ${response.data ?? 'No data came back'}');

      if (response.data == null) return false;
      return true;
    }
    catch (e) {
      print('There was an error $e');
      return false;
    }
  }
}

class CallStatus {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> createCall(String channelId, String callerUid, String calleeUid) async {
    await _db.collection('calls').doc(channelId).set({
      'callerUid': callerUid,
      'calleeUid': calleeUid,
      'status': 'calling',
    });
  }

  static Future<void> updateCallStatus(String channelId, String status) async {
    await _db.collection('calls').doc(channelId).update({'status': status});
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getCallStatusStream(String channelId) {
    return _db.collection('calls').doc(channelId).snapshots();
  }
}
