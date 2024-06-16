import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  late RtcEngine _engine;
  final Completer<void> _initializationCompleter = Completer<void>();

  Future<void> initializeAgora() async {
    _engine = await createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: 'aec78a192db346b5ac2aa272530413a7',
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    await _engine.setChannelProfile(ChannelProfileType.channelProfileCommunication);
    await _engine.enableAudio();

    await [Permission.microphone].request();

    _initializationCompleter.complete();

    _setupEventHandlers();


  }


  void _setupEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('onJoinChannelSuccess: ${connection.channelId}, $elapsed');
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          print('onUserJoined: $uid, $elapsed');
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          print('onLeaveChannel');
        },
        onUserOffline: (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          print('onUserOffline: $uid, $reason');
        },
      ),
    );
  }

  Future<void> joinChannel(String token, String channelName,) async {
    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: false,
      ),
    );
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
  }

}
