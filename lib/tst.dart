import 'package:flutter/material.dart';

import 'package:voice_call_app/services/agora_service.dart';

import '../model/user_model.dart';
import '../services/firebase_messaging_service.dart';


class CallScreenn extends StatefulWidget {




  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreenn> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(height: 20),

            GestureDetector(
              onTap: () async {

              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(100)
                ),

                child: Center(child: Text('Call', style: TextStyle(fontSize: 30, color: Colors.white),)),

              ),
            ),
          ],
        ),
      ),
    );
  }
}