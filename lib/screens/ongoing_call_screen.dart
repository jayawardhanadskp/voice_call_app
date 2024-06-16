import 'dart:async';

import 'package:flutter/material.dart';

import '../services/agora_service.dart';

class OngoingCallScreen extends StatefulWidget {

  final String channelName;
  final String callerName;
  final AgoraService agoraService;

  const OngoingCallScreen({
    Key? key,
    required this.channelName,
    required this.callerName,
    required this.agoraService,
  }) : super(key: key);

  @override
  State<OngoingCallScreen> createState() => _OngoingCallScreenState();
}

class _OngoingCallScreenState extends State<OngoingCallScreen> {

  final AgoraService _agoraService = AgoraService();
  late String _channelName;

  late Timer _timer;
  int _callDuration = 0;
  String _formattedDuration = "00:00";

  @override
  void initState() {
    super.initState();
   _channelName = widget.channelName;
   _initAgora();
    _startCallTimer();
  }

  Future<void> _initAgora() async {
    await _agoraService.initializeAgora();
    await _agoraService.joinChannel('007eJxTYLjPar3txOPi5qltzzZXuIgeOznv8l2VV0z1oXtaYto6pvkrMCSmJptbJBpaGqUkGZuYJZkmJhslJhqZG5kaG5gYGieav/mfm9YQyMjwMOszIyMDBIL4hHUyMAAATHMppQ==',_channelName);
  }

  @override
  void dispose() {
    _timer.cancel();
   widget.agoraService.leaveChannel();
    super.dispose();
  }

  void _startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Call Duration: $_formattedDuration',
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
            const SizedBox(height: 300,),


            ElevatedButton(
                onPressed: () async{
                  await _agoraService.leaveChannel();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,

                ),
                child: const Text('End Call', style: TextStyle(color: Colors.white),)
            ),
          ],
        ),
      ),
    );
  }
}
