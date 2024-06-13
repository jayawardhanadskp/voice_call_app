import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/firebase_messaging_service.dart';
import 'call_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<UserModel> _users = [
    UserModel(id: 'user0@example.com', name: '', token: 'ds7QPlt2TCCkvDSvZu5MNA:APA91bFRNjvJALSDJnf4hf9-mrX1stpU7VsdqglkrUUJKpt4j4CJJjgFT-Vl-29mfnWNv2PB5shpZb9iJlJQtle6xON2IIkqyVmnpn_5jaKwm9CyMUnRf97biGVGuBwowUbXrhNDo4a2'),
    UserModel(id: 'user2@example.com', name: 'User 2', token: 'fzVvPnDkS3eh99IFIRkenF:APA91bEFz0fDSEJG0jffZeOybwwdCOiobfXvSM0f9oH6oNUZKO0b80UVNV6xDLWrOgZBh1ushsOm1ObQQlwFaHcABI6zobOwEklQmUrK6WeheF_uIBkBvvb2QoKnMchfh2LuAWPzdczX'),
    UserModel(id: 'user1@example.com', name: 'User 1', token: 'ds7QPlt2TCCkvDSvZu5MNA:APA91bFRNjvJALSDJnf4hf9-mrX1stpU7VsdqglkrUUJKpt4j4CJJjgFT-Vl-29mfnWNv2PB5shpZb9iJlJQtle6xON2IIkqyVmnpn_5jaKwm9CyMUnRf97biGVGuBwowUbXrhNDo4a2'),

  ];

  FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _saveUserTokens();
  }

  Future<void> _saveUserTokens() async {
    for (UserModel user in _users) {
      await _firebaseService.saveToken(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
            child: Container(
              color: Colors.blue,
              child: ListTile(
                title: Align(
                  alignment: Alignment.center,
                  child: Text(
                    _users[index].name,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () async {
                  String? token = await _firebaseService.getTokenForUser(_users[index].id);
                  if (token != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          user: _users[index],
                          token: _users[index].token.toString(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
