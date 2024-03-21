import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_using_firebase/provider/firebase_provider.dart';
import 'package:live_chat_using_firebase/screen/main_screen.dart';
import 'package:provider/provider.dart';

import 'Screen/chats_screen.dart';
import 'constant.dart';
import 'firebase_options.dart';

// create background handler for firebase messaging notification
Future<void> _backgroundMessageHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async{
  //used to bind the services
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase to application
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //initialize Firebase Messaging to application
  await FirebaseMessaging.instance.getInitialMessage();

  // used to allow in background Firebase notification
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  runApp(const MyApp());
}
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FirebaseProvider(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Google AdMob',
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        theme: ThemeData(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  textStyle:
                  const TextStyle(fontSize: 20),
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: mainColor),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            )),
        home: const MainScreen(),
      ),
    );
  }
}
