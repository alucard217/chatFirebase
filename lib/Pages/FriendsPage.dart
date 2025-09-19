import 'package:chat/predoneDesigns/Designs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ChatPage.dart';


class FriendsPage extends StatefulWidget{
  const FriendsPage({super.key});

  @override
  State<StatefulWidget> createState() => _FriendsPageState();

}

class _FriendsPageState extends State<FriendsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Expanded(
          child: _buildFriendsList()
      )
    );
  }


  Widget _buildFriendsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildFriendsListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildFriendsListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if ("1dauren4ik@gmail.com" != data["email"]) {
      return MyListTile(
        title: data["email"],
        pfpURL: "",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatPage(
                    receiverUserEmail: data["email"],
                  ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}