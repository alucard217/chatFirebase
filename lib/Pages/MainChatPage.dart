import 'package:chat/Pages/FriendsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../predoneDesigns/Designs.dart';
import 'ChatPage.dart';

class UsersChat extends StatefulWidget {
  const UsersChat({super.key});

  @override
  State<StatefulWidget> createState() => _UsersChatState();
}

class _UsersChatState extends State<UsersChat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => FriendsPage(),
                ),);
              },
              icon: Icon(Icons.person, color: Theme.of(context).colorScheme.inversePrimary,)
          ),
          IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.inversePrimary,)
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          _searchUser(),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildUserList() {
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
              .map<Widget>((doc) => _buildUserListItem(doc, searchController.text))
              .toList(),
        );
      },
    );
  }

  Widget _searchUser() {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
      margin: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(20),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hint: Text(
                  "Search",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                border: InputBorder.none,
              ),
              controller: searchController,
              onChanged: (value){
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document, String searchText) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if ("1dauren4ik@gmail.com" != data["email"] && data["email"].toString().toLowerCase().contains(searchText.toLowerCase())) {
      return MyListTile(
        title: data["fullName"],
        pfpURL: "https://firebasestorage.googleapis.com/v0/b/login-page-801a7.firebasestorage.app/o/avatars%2FA4ATklz0BedfNIC5jzaJXlZs0Jn1.jpg?alt=media&token=9c5b0b45-99d5-44ca-b17c-b65818434da7",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
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
