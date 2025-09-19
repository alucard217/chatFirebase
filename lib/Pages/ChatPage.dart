import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/Chat_Service.dart';
import '../predoneDesigns/Designs.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;

  const ChatPage({super.key, required this.receiverUserEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String receiverNickname = "";
  late String receiverProfilePictureURL = "";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReceiverData();
  }

  Future<void> loadReceiverData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: widget.receiverUserEmail)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          receiverNickname = data["fullName"] ?? "Unknown";
          receiverProfilePictureURL = data["photoUrl"] ?? "";
          isLoading = false;
        });
      } else {
        setState(() {
          receiverNickname = "Unknown";
          receiverProfilePictureURL = "";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Ошибка при загрузке данных получателя: $e");
      setState(() {
        receiverNickname = "Unknown";
        receiverProfilePictureURL = "";
        isLoading = false;
      });
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUserEmail,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blue,)),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: receiverProfilePictureURL.isNotEmpty
                  ? NetworkImage(receiverProfilePictureURL)
                  : null,
              child: receiverProfilePictureURL.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              receiverNickname,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        "1dauren4ik@gmail.com",
        widget.receiverUserEmail,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView(
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String currentEmail = "1dauren4ik@gmail.com";

    return MessageBubble(
      data: data,
      alignment: (data['senderEmail'] == currentEmail)
          ? Alignment.centerRight
          : Alignment.centerLeft,
      crossAxisAlignment: (data['senderEmail'] == currentEmail)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      color: (data['senderEmail'] == currentEmail)
          ? Colors.green
          : Colors.blue,
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Enter message",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward, size: 40),
          ),
        ],
      ),
    );
  }
}

