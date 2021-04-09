import 'package:flutter/material.dart';
import 'home/EmailSender.dart';
import 'services/DatabaseService.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static DatabaseService database = new DatabaseService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.lightGreen),
      home: EmailSender(database: database),
    );
  }
}
