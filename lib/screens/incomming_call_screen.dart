import 'package:flutter/material.dart';
import '../services/agora_service.dart';
import '../services/firebase_helper.dart';
import 'ongoing_call_screen.dart';

class IncommingCallScreen extends StatefulWidget {
  final String callingUserName;
  final String channelName;

  const IncommingCallScreen({
    Key? key,
    required this.callingUserName,
    required this.channelName,
  }) : super(key: key);

  @override
  State<IncommingCallScreen> createState() => _IncommingCallScreenState();
}

class _IncommingCallScreenState extends State<IncommingCallScreen> {
  final AgoraService _agoraService = AgoraService();
  bool _isInitialized = false;
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    if (!_isInitialized) {
      print("Initializing Agora...");
      try {
        await _agoraService.initializeAgora();
        setState(() {
          _isInitialized = true;
        });
        print("Agora initialized successfully.");
      } catch (e) {
        print("Error initializing Agora: $e");
      }
    } else {
      print("Agora already initialized.");
    }
  }

  Future<void> _joinChannel() async {
    if (_isInitialized && !_isJoining) {
      setState(() {
        _isJoining = true;
      });
      print("Joining channel...");
      try {
        await _agoraService.joinChannel(
          '007eJxTYPhpwDqrJnlh49zOC+I1K65nVQetyzh6ZW709Pjlsg284r0KDImpyeYWiYaWRilJxiZmSaaJyUaJiUbmRqbGBiaGxonmLd/z0hoCGRmUPgQxMjJAIIhPWCcDAwBOACar', // Replace with your Agora token
          widget.channelName,
        );
        await CallStatus.updateCallStatus(widget.channelName, 'ongoing');
        print("Joined channel successfully.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OngoingCallScreen(
              channelName: widget.channelName,
              callerName: widget.callingUserName,
              agoraService: _agoraService,
            ),
          ),
        );
      } catch (e) {
        print("Error joining channel: $e");
      } finally {
        setState(() {
          _isJoining = false;
        });
      }
    } else {
      print("Cannot join channel. Initialized: $_isInitialized, Joining: $_isJoining");
    }
  }

  @override
  void dispose() {
    print("Leaving channel...");
    _agoraService.leaveChannel();
    super.dispose();
  }

  void _onAnswerButtonPressed() {
    _joinChannel();
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
              'Calling from ${widget.callingUserName}',
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
            const SizedBox(height: 300),
            ElevatedButton(
              onPressed: _onAnswerButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
              ),
              child: const Text(
                'Answer',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic to handle call rejection if necessary
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'End Call',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
