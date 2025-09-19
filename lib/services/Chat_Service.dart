import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../classes/message.dart';

class ChatService extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverEmail, String message) async{
    final String currentUser = "1dauren4ik@gmail.com";
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderEmail: currentUser,
        receiverEmail: receiverEmail,
        message: message,
        timestamp: timestamp,
    );

    List<String> ids = [currentUser, receiverEmail];
    ids.sort();
    String ChatRoomID = ids.join("_");

    await _firestore.collection("chat_rooms").doc(ChatRoomID).collection("messages").add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String senderEmail, String receiverEmail) {
    List<String> ids = [senderEmail, receiverEmail];
    ids.sort();
    String ChatRoomID = ids.join("_");

    return _firestore.collection("chat_rooms").doc(ChatRoomID).collection("messages").orderBy('timestamp', descending: false).snapshots();

  }
}