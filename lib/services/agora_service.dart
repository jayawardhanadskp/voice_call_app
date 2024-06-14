import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  late RtcEngine _engine;

  Future<void> initializeAgora() async {
    _engine = await createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: 'aec78a192db346b5ac2aa272530413a7',
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    await _engine.setChannelProfile(ChannelProfileType.channelProfileCommunication);
    await _engine.enableAudio();


  }

  Future<void> joinChannel(String channelName,) async {
    await _engine.joinChannel(
      token: '007eJxTYLhg49/OpLTn2mPdnfIzlVedrjQXevvQdt4ilUv1/+YsS0tWYEhMTTa3SDS0NEpJMjYxSzJNTDZKTDQyNzI1NjAxNE40D/6WldYQyMgwv6+XlZGBlYGRgYkBxGdgAADBWR6s',
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
