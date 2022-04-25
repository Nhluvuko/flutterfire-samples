import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_samples/res/custom_colors.dart';
import 'package:flutterfire_samples/screens/edit_screen.dart';
import 'package:flutterfire_samples/utils/firestore_database.dart';
import 'package:flutterfire_samples/utils/realtime_database.dart';

class ItemList extends StatefulWidget {

  

  @override
  State<StatefulWidget> createState() {
    return _ItemList();
  }
}

class _ItemList extends State<ItemList> {

  List<dynamic> items = [];

  final database = RealtimeDatabase();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: database.readItems(),
      builder: (context, snapshot,) {
        database.readItems();
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            
            itemCount: snapshot.data!.snapshot.children.length,//snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var noteInfo = "";//snapshot.data!.value!;
            


              database.updateData(snapshot.data!.snapshot.children);
              String docID = database.data2[index]["id"];
              String title = database.data2[index]["data"]["title"];
              String description = database.data2[index]["data"]["description"];

              

              return Ink(
                decoration: BoxDecoration(
                  color: CustomColors.firebaseGrey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        currentTitle: title,
                        currentDescription: description,
                        documentId: docID,
                      ),
                    ),
                  ),
                  title: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              CustomColors.firebaseOrange,
            ),
          ),
        );
      },
    );
  }

  transfromData(items) {

    var transformed = [];
    transformed.forEach((element) {
          transformed.add(<String, dynamic>{
            "id": element.key,
            "data": element.value,
          });
      });
    return transformed;
  }
}
