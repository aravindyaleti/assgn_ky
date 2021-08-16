
import 'package:cloud_firestore/cloud_firestore.dart';

class DataProvider{
  final db=Firestore.instance;

  Stream<QuerySnapshot>movies(){
    return db.collection('Movies').snapshots();
  }
}

DataProvider dataProvider=new DataProvider();