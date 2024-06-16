
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';
import '../services/firebase_helper.dart';
import '../widget/user_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseHelper.buildViews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final List<UserModel> users = [];
            final List<QueryDocumentSnapshot>? docs = snapshot.data?.docs;
            if (docs == null && docs!.isEmpty) {
              return Text('No Data');
            }

            for(var doc in docs) {
              if (doc.data() != null) {
                users.add(UserModel.fromJson(doc.data() as Map<String, dynamic>)
                );
              }

            }
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return UserWidget(model: users[index]);
                },
            );
          }
        ),
      )
    );
  }
}

