import 'dart:async';

import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/agora_service.dart';
import '../services/firebase_messaging_service.dart';

class CallingScreen extends StatefulWidget {
  final UserModel user;
  final String token;

  CallingScreen({required this.user, required this.token});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallingScreen> {
  final AgoraService _agoraService = AgoraService();
  final FirebaseService _firebaseService = FirebaseService();

  late String _channelName;
  late Timer _timer;
  int _callDuration = 0;
  String _formattedDuration = "00:00";

  @override
  void initState() {
    super.initState();
    _channelName = 'channel_${widget.user.id}';
    _initAgora();
    _startCallTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _agoraService.leaveChannel();
    super.dispose();
  }

  Future<void> _initAgora() async {
    await _agoraService.initializeAgora();
    await _agoraService.joinChannel(_channelName);
    await _firebaseService.sendMessage(widget.token, 'Incoming call from ${widget.user.name}');
  }

  void _startCallTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
        _formattedDuration = _formatDuration(_callDuration);
      });
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void _endCall() {
    _timer.cancel();
    _agoraService.leaveChannel();
    Navigator.pop(context);
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
            Text(
              'Call Duration: $_formattedDuration',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _endCall,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Text(
                    'End Call',
                    style: TextStyle(fontSize: 20, color: Colors.white),
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
