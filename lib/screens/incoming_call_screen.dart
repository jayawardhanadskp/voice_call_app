import 'package:flutter/material.dart';
import 'package:voice_call_app/services/agora_service.dart';
import '../model/user_model.dart';

class IncomingCallScreen extends StatefulWidget {
  final UserModel caller;
  final String channelName;

  IncomingCallScreen({required this.caller, required this.channelName});

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  AgoraService _agoraService = AgoraService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incoming Call from ${widget.caller.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Incoming call from ${widget.caller.name}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Accept'),
                  onPressed: () async {
                    await _agoraService.joinChannel(widget.channelName);
                  },
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  child: const Text('Reject'),
                  onPressed: () {
                    Navigator.pop(context);
                    _agoraService.leaveChannel();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
