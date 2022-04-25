import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

final FirebaseDatabase _database = FirebaseDatabase.instance;
var persist  = _database.setPersistenceEnabled(true);

class RealtimeDatabase with ChangeNotifier{
  static String? userUid;
  static Map<String, dynamic>? data = new Map();
  
  List data2 = [];
  static var uuid = Uuid();
  

  static Future<void> addItem({
    required String title,
    required String description,
  }) async {
    DatabaseReference itemRef = FirebaseDatabase.instance.ref("$userUid/${uuid.v4()};");

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
    required String refId,
  }) async {
    DatabaseReference itemRef = FirebaseDatabase.instance.ref("$userUid/$refId");

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

   

    await itemRef
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  readItems() {
    var ref = FirebaseDatabase.instance.ref("$userUid");
    ref.keepSynced(true);
    return ref.onValue;
  }

  updateData(items) {
    data2 = [];
    items.forEach((element) {
          data2.add(<String, dynamic>{
            "id": element.key,
            "data": element.value,
          });
      });
      notifyListeners();
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
