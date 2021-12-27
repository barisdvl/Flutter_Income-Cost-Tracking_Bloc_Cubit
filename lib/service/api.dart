import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class Api {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final String path;

  CollectionReference? ref;

  Api(this.path) {
    ref = _database.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref!.get();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref!.orderBy("transaction_date", descending: true).snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref!.doc(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref!.doc(id).delete();
  }

  Future<void> addDocument(Map data, context) {
    return ref!
        .add(data)
        .then((value) => MotionToast.success(
              title: "Success",
              titleStyle: TextStyle(fontWeight: FontWeight.bold),
              description: "Entry Added",
              descriptionStyle: TextStyle(fontSize: 12),
              position: MOTION_TOAST_POSITION.BOTTOM,
              animationType: ANIMATION.FROM_LEFT,
              width: 300,
            ).show(context))
        .catchError((error) => MotionToast.error(
                title: "Error",
                titleStyle: TextStyle(fontWeight: FontWeight.bold),
                description: "Failed to add entry: $error")
            .show(context));
  }

  Future<void> updateDocument(Map<String, dynamic> data, String id) {
    return ref!.doc(id).update(data);
  }
}
