import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../screen/chat_screen.dart';

class NotificationsService{
  // Cloud Messaging API key
  static const key = "AAAAxH3fA6o:APA91bGT7kX9D7J77B9__mhdwOE4FONf17xtse4FNE4X_0YZu6DtGQX6SZdVy1z5xfS7mZxTLzCLsZD2tMcON-mGvEpnaVdIHYGmFuDoh9ePVdhdQQ6azu1bKL_qdUvwXTOLEHkfIlLm";

  // initialize flutter local notification plugin
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // initialize notification
  void _initLocalNotification() {
    // initialize notification for android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // initialize notification for iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
    );

    // initialize settings of android and iOS
    const initializationSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint(response.payload.toString());
        });
  }

  // used show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {

    //used to define the style of the notification content
    final styleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatTitle: true,
    );

    // configures the behavior and appearance of the notification on Android
    final androidDetails = AndroidNotificationDetails(
      'com.example.liveChatUsingFirebase',
      'mychannelid',
      importance: Importance.max,
      styleInformation: styleInformation,
      priority: Priority.max,
    );

    // configures notification for iOS using DarwinNotificationDetails
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );

    // combines both Android and iOS notification details
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    //display the notification
    await flutterLocalNotificationsPlugin.show(
        0, // id for notification
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['body']);
  }

  // used te request permission for notification
  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  // get the token of FirebaseMessaging and save into users collection
  Future<void> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    _saveToken(token!);
  }

  // save the token of FirebaseMessaging into users collection
  Future<void> _saveToken(String token) async =>
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token}, SetOptions(merge: true));

  String receiverToken = '';

  // get the token of FirebaseMessaging from users collection
  Future<void> getReceiverToken(String? receiverId) async {
    final getToken = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();

    receiverToken = await getToken.data()!['token'];
  }

  // initialize firebase notification service
  void firebaseNotification(context) {

    // call initialize local notification
    _initLocalNotification();

    // tap on notification to open chat screen
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ChatScreen(userId: message.data['senderId']),
        ),
      );
    });

    FirebaseMessaging.onMessage
        .listen((RemoteMessage message) async {
      await _showLocalNotification(message);
    });
  }

  // call the API of send notification
  Future<void> sendNotification({required String body, required String senderId}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$key',
        },
        body: jsonEncode(<String, dynamic>{
          "to": receiverToken,
          'priority': 'high',
          'notification': <String, dynamic>{
            'body': body,
            'title': 'New Message !',
          },
          'data': <String, String>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'senderId': senderId,
          }
        }),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}