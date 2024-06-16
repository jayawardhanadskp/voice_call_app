import 'package:flutter/material.dart';

import '../services/agora_service.dart';
import 'ongoing_call_screen.dart';

class IncommingCallScreen extends StatefulWidget {

  final String callingUserName;
  final String channelName;

  const IncommingCallScreen({
    Key? key,
    required this.callingUserName,
    required this.channelName,
  });

  @override
  State<IncommingCallScreen> createState() => _IncommingCallScreenState();
}

class _IncommingCallScreenState extends State<IncommingCallScreen> {

  final AgoraService _agoraService = AgoraService();

  @override
  void initState() {
    super.initState();


    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    await _agoraService.initializeAgora();
  }

  Future<void> _initializeAgoraAndJoinChannel() async {

    setState(() {
       _agoraService.joinChannel(
          '007eJxTYLjPar3txOPi5qltzzZXuIgeOznv8l2VV0z1oXtaYto6pvkrMCSmJptbJBpaGqUkGZuYJZkmJhslJhqZG5kaG5gYGieav/mfm9YQyMjwMOszIyMDBIL4hHUyMAAATHMppQ==',
          widget.channelName);
    });
  }

  @override
  void dispose() {
    _agoraService.leaveChannel();
    super.dispose();
  }

  void _onAnswerButtonPressed() async {
    try {
      await _initializeAgoraAndJoinChannel();
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
    }
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
            Text('Calling from ${widget.callingUserName}', style: const TextStyle(color: Colors.white, fontSize: 25),),

            const SizedBox(height: 300,),

            ElevatedButton(
                onPressed: _onAnswerButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,

                ),
                child: const Text('Answer', style: TextStyle(color: Colors.white),)
            ),
            const SizedBox(height: 20,),

            ElevatedButton(
                onPressed: () {

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
