import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/agora_service.dart';
import '../services/firebase_messaging_service.dart';

class CallScreen extends StatefulWidget {
  final UserModel user;
  final String token;

  CallScreen({required this.user, required this.token});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  AgoraService _agoraService = AgoraService();
  FirebaseService _firebaseService = FirebaseService();

  late String _channelName;

  @override
  void initState() {
    super.initState();
    _channelName = 'channel_${widget.user.id}';
    _initAgora();
  }

  Future<void> _initAgora() async {
    await _agoraService.initializeAgora();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call ${widget.user.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await _agoraService.joinChannel(_channelName);
                await _firebaseService.sendMessage(widget.token, 'Incoming call from ${widget.user.name}');
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
