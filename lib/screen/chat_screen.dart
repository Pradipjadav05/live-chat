import 'package:flutter/material.dart';
import 'package:live_chat_using_firebase/model/user_model.dart';
import 'package:provider/provider.dart';

import '../provider/firebase_provider.dart';
import '../widgets/chat_messages.dart';
import '../widgets/chat_text_field.dart';

class ChatScreen extends StatefulWidget {
  final String userId;

  const ChatScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    //get user details by id & get all message of this(id) user
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(widget.userId)
      ..getMessages(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // build ui of messages
            ChatMessages(receiverId: widget.userId),
            //build ui of text field of send messages
            ChatTextField(receiverId: widget.userId)
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        title: Consumer<FirebaseProvider>(
          builder: (context, value, child) => value.user != null
              ? Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(value.user!.image),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          value.user!.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          value.user!.isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            color: value.user!.isOnline
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      );
}
