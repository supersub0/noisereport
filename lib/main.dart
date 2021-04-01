import 'dart:core';
import 'package:flutter/material.dart';
import 'EmailSender.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCsbBpc_f1oV8BUvbOajEJa4txyp-2wnOs",
      messagingSenderId: "104207850087097986518",
      appId: "1:kukukonline:web:kukukonline",
      projectId: "kukukonline",
    )
  );
  assert(app != null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.lightGreen),
      home: EmailSender(analytics: analytics, observer: observer),
    );
  }
}
