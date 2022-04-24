import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase _database = FirebaseDatabase.instance;
final DatabaseReference _databaseReference = _database.ref();

class RealtimeDatabase {
  static String? userUid;
  static Map<String, dynamic>? data = new Map();
  static List data2 = [];
  
  

  static Future<void> addItem({
    required String title,
    required String description,
  }) async {
    DatabaseReference itemRef = FirebaseDatabase.instance.ref("users/$userUid");

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await itemRef
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DatabaseReference itemRef = FirebaseDatabase.instance.ref("users/$userUid");

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

   

    await itemRef
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static readItems() {

    return FirebaseDatabase.instance.ref("notes/$userUid").onValue;
    
    FirebaseDatabase.instance.ref("notes/$userUid").onValue.listen((DatabaseEvent event) {
      event.snapshot.children.length;
      event.snapshot.children.forEach((element) {
          log(element.key.toString());
          data2.add(<String, dynamic>{
            "title": element.key,
            "description": element.value,
          });
      });
    });
  }

  static updateData(items) {

    items.forEach((element) {
          log(element.key.toString());
          log(element.value.toString());
          log("------------------");
          data2.add(<String, dynamic>{
            "title": element.key,
            "description": element.value,
          });
      });
  }

  /*
  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
  */
}
