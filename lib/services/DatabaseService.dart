import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference zipDateTime = FirebaseFirestore.instance.collection('zipDateTime');

  Future logZipDateTime(String zip, DateTime dateTime) async {
    await zipDateTime.add({
      'zip': zip,
      'dateTime': dateTime,
    });
  }
}
