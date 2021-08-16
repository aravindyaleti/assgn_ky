

import 'package:firebase_auth/firebase_auth.dart';

class UserServices{
  FirebaseUser user;
  getUser()async{
    FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      user=event;
    });

  }
}

UserServices userServices=new UserServices();