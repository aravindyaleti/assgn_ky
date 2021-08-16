import 'dart:async';

import 'package:assgn_ky/components/movie_card.dart';
import 'package:assgn_ky/models/auth.dart';
import 'package:assgn_ky/models/data.dart';
import 'package:assgn_ky/new_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'edit.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Future _user()async{
    userServices.getUser();
    Timer(Duration(seconds: 5), (){
      if(userServices.user!= null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>MyHomePage()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Login()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _user();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(child: CircularProgressIndicator(),)
    ),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,
        title: Text("Assignment"),
        actions: [
          IconButton(icon: Icon(Icons.add_circle_outline), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>NewForm()));
          })
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: dataProvider.movies(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return snapshot.data.documents.length>0?ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MovieCard(snapshot: snapshot.data.documents[index],onEdit: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>EditMovie(snapshot:snapshot.data.documents[index])));
                  },);
                },
              ):Container(height: MediaQuery.of(context).size.height * 0.3,
                child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: const EdgeInsets.only(bottom: 8, top: 12),
                      child: Center(child: Text('No movie list available!', style: TextStyle(color: Colors.grey))),
                    ),

                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }
      )
    );
  }
}
