import 'package:flutter/material.dart';

class CallingScreen extends StatefulWidget {

  final String selectUser;
  const CallingScreen({
    Key? key,
    required this.selectUser
  }): super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
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
