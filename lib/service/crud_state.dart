import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CRUDState {
  CRUDState();
}

class BeginnerState extends CRUDState {
  BeginnerState();
}

class DatabaseLoading extends CRUDState {
  DatabaseLoading();
}

class DatabaseLoaded extends CRUDState {
  List<Map<String, dynamic>> sumAccountList = [];
  List<Map<String, dynamic>> sumTotalList = [];
  DatabaseLoaded(this.sumAccountList, this.sumTotalList);
}

class DatabaseError extends CRUDState {
  String errorMessage;
  DatabaseError(this.errorMessage);
}
