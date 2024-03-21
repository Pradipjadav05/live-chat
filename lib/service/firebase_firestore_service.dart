import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../model/message_model.dart';
import '../model/user_model.dart';
import 'firebase_storage_service.dart';

class FirebaseFirestoreService{
  static final firestore = FirebaseFirestore.instance;

  // create user at register time
  static Future<void> createUser({
    required String name,
    required String image,
    required String email,
    required String uid,
  }) async {
    final user = UserModel(
      uid: uid,
      email: email,
      name: name,
      image: image,
      isOnline: true,
      lastActive: DateTime.now(),
    );

    await firestore
        .collection('users')
        .doc(uid)
        .set(user.toJson());
  }

  // create model data of text message and insert record to firestore database
  static Future<void> addTextMessage({
    required String content,
    required String receiverId,
  }) async {
    final message = Message(
      content: content,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    // call the add message text methods
    await _addMessageToChat(receiverId, message);
  }

  // create model data of image message and insert record to firestore database
  static Future<void> addImageMessage({
    required String receiverId,
    required Uint8List file,
  }) async {
    final image = await FirebaseStorageService.uploadImage(
        file, 'image/chat/${DateTime.now()}');

    final message = Message(
      content: image,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.image,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    // call the add image message methods
    await _addMessageToChat(receiverId, message);
  }

  // insert message to sender and receiver id
  static Future<void> _addMessageToChat(
      String receiverId,
      Message message,
      ) async {

    // insert record of sender
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    // insert record of receiver
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(message.toJson());
  }

  // update user data
  static Future<void> updateUserData(
      Map<String, dynamic> data) async =>
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);

  // search user by name
  static Future<List<UserModel>> searchUser(
      String name) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("name", isGreaterThanOrEqualTo: name)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();
  }
}