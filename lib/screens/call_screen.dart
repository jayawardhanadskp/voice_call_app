import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_call_app/screens/calling_screen.dart';

import '../services/agora_service.dart';
import '../services/firebase_helper.dart';

class CallScreen extends StatefulWidget {

  final String token;
  final String selectUser;
  const CallScreen({
    Key? key,
    required this.token,
    required this.selectUser
  }): super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final AgoraService _agoraService = AgoraService();
String currentUserName = '';

late String _channelName;

@override
  void initState() {
  _getCurrentUserName();
  _channelName = 'channelName';
  _initAgora();
    super.initState();
  }

Future<void> _initAgora() async {
  await _agoraService.initializeAgora();
}

  Future<void> _getCurrentUserName() async{
  try{
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        currentUserName = userDoc['name'];
      });
    }  
  } catch (e) {
    print('Fail to get user name: $e');
  }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[

            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {

                await _agoraService.joinChannel(
                    '007eJxTYPhpwDqrJnlh49zOC+I1K65nVQetyzh6ZW709Pjlsg284r0KDImpyeYWiYaWRilJxiZmSaaJyUaJiUbmRqbGBiaGxonmLd/z0hoCGRmUPgQxMjJAIIhPWCcDAwBOACar',
                    _channelName
                );

                await FirebaseHelper.sendNotification(
                  title: 'You Have a Cll',
                  body: 'call from $currentUserName',
                  token: widget.token,
                  channelName: _channelName,
                  callerName: currentUserName,
                );

                await CallStatus.createCall(
                     _channelName,
                     currentUserName,
                     _channelName
                );

                Navigator.push(context, MaterialPageRoute(
                    builder: (context)
                    => CallingScreen(
                      selectUser: widget.selectUser,
                        channelName: _channelName,
                        callerName: currentUserName,
                        agoraService: _agoraService,
                )));
                },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Center(
                  child: Text(
                    'Call',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
