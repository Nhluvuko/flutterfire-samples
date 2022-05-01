import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';



class RealtimeDatabase with ChangeNotifier{
  
  static String? userUid;
  static Map<String, dynamic>? data = new Map();
  
  List data2 = [];
  static var uuid = Uuid();

  static var database = FirebaseDatabase.instance;

  RealtimeDatabase(){
    database.setPersistenceEnabled(true);
  }
  

  static Future<void> addItem({
    required String title,
    required String description,
  }) async {
    DatabaseReference itemRef = database.ref("$userUid/${uuid.v4()};");

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    itemRef
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    required String title,
    required String description,
    required String refId,
  }) async {
    DatabaseReference itemRef = database.ref("$userUid/$refId");

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

   

    itemRef
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  readItems() {
    var ref = database.ref("$userUid");
    ref.keepSynced(true);
    
    ref.get().then((value) => {
      value.children.forEach((element) {
        log(element.value.toString());
      })
    });
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

  
  static Future<void> deleteItem({
    required String docId,
  }) async {
    
    DatabaseReference itemRef = database.ref("$userUid/$docId");

    itemRef
        .remove()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
