import 'package:flutter/material.dart';

import '../services/agora_service.dart';
import '../services/firebase_helper.dart';
import 'ongoing_call_screen.dart';

class CallingScreen extends StatefulWidget {

  final String callerName;
  final String channelName;
  final String selectUser;
  final agoraService;

  const CallingScreen({
    Key? key,
    required this.selectUser,
    required this.callerName,
    required this.channelName,
    required this.agoraService,
  }): super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {

  final AgoraService _agoraService = AgoraService();

  @override
  void initState() {
    super.initState();


    _initAgora();
    _listenToCallStatus();
  }

  Future<void> _initAgora() async {
    await _agoraService.initializeAgora();
  }

  void _listenToCallStatus() {
    CallStatus.getCallStatusStream(widget.channelName).listen((snapshot) {
      if (snapshot.exists && snapshot.data()?['status'] == 'ongoing') {
        // Navigate to OngoingCallScreen when call status is 'ongoing'
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OngoingCallScreen(
              channelName: widget.channelName,
              callerName: widget.callerName,
              agoraService: _agoraService,
            ),
          ),
        );
      }
    });
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
            Text('Calling ${widget.selectUser}', style: TextStyle(color: Colors.white, fontSize: 25),),

            SizedBox(height: 300,),

            ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,

                ),
                child: Text('End Call', style: TextStyle(color: Colors.white),)
            ),
          ],
        ),
      ),
    );
  }
}
