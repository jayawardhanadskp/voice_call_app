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
    try {
      print("Initializing Agora in OngoingCallScreen...");
      await widget.agoraService.initializeAgora();
      await widget.agoraService.joinChannel(
        '007eJxTYPhpwDqrJnlh49zOC+I1K65nVQetyzh6ZW709Pjlsg284r0KDImpyeYWiYaWRilJxiZmSaaJyUaJiUbmRqbGBiaGxonmLd/z0hoCGRmUPgQxMjJAIIhPWCcDAwBOACar', // Replace with your Agora token
        _channelName,
      );
      print("Agora initialized and channel joined successfully.");
    } catch (e) {
      print("Error initializing Agora in OngoingCallScreen: $e");
    }
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
            const SizedBox(height: 300),
            ElevatedButton(
              onPressed: () async {
                await widget.agoraService.leaveChannel();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('End Call', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
