import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class NewForm extends StatefulWidget {
  const NewForm({Key key}) : super(key: key);

  @override
  _NewFormState createState() => _NewFormState();
}

class _NewFormState extends State<NewForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  File img;
  String name;
  String director;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(elevation: 0,title: Text("New Movie",style: GoogleFonts.poppins(),),
      leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
        Navigator.pop(context);
      }),
    ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.2,
            color: Colors.white,
            child: GestureDetector(
              child: DottedBorder(
                color: Colors.black,
                strokeWidth: 1,
                child: img==null?Center(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined),
                      SizedBox(height: 10),
                      Text("Add Movie Poster",style: GoogleFonts.poppins(),),
                    ],
                  ),
                ):Image.file(img,
                  width: MediaQuery.of(context).size.width,fit: BoxFit.cover,),
              ),
              onTap: ()async{
                final  image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 70);
                if(image!=null){
                  setState(() {
                    img=image;
                  });
                }
              },
            ),
          ),
        ),
        Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Movie name', border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  validator: (String arg) {
                    if(arg.length < 3)
                      return 'Name should not be empty';
                    else
                      return null;
                  },
                  onSaved: (String val) {
                    name = val;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Director name',border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  validator: (String arg) {
                    if(arg.length < 3)
                      return 'Director name required*';
                    else
                      return null;
                  },
                  onSaved: (String val) {
                    director = val;
                  },
                ),
              ),
              new SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8,top: 12,bottom: 12,right: 8),
                child: MaterialButton(elevation: 0,
                    height: 50,
                    color: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 52.0),
                      child: Text(
                          "Save",
                          style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18)
                      ),
                    ),
                    onPressed: _validateInputs
                ),
              )
            ],
          ),
        ),
      ],),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if(img!=null){
        _upload();
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future _upload()async{
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    showDialog(context: context,builder: (context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }, barrierDismissible: false);
    String url;
    if(img!=null){
      StorageReference ref = FirebaseStorage.instance.ref().child("images").child(DateTime.now().millisecondsSinceEpoch.toString());
      final task = ref.putFile(img);
      await task.onComplete;
      url = await ref.getDownloadURL();
      setState(() {

      });
    }
    DocumentReference reference=Firestore.instance.collection('Movies').document();
    reference.setData({
      'image':url,
      'productID':reference.documentID,
      'name':name,
      'director':director,
    },merge: true).then((value){
      setState(() {
        name='';
        director='';
        img=null;
      });
      Navigator.pop(context);
      _success();
    }).catchError((onError){
      Navigator.pop(context);
      Fluttertoast.showToast(msg: onError.toString(),timeInSecForIosWeb: 30,webShowClose: true,gravity: ToastGravity.CENTER);
    });
  }

  void _success(){
    showDialog(context: context, builder: (context)=>Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(child: Icon(Icons.check_sharp,color: Colors.white,size: 45,),backgroundColor: Colors.lightGreen,radius: 40,),
              Text('Success',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey),),
              Padding(
                padding: const EdgeInsets.only(left: 25,right: 25,top: 18,bottom: 18),
                child: Text('New movie has added successfully in your movie list',style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,),
              ),
              Container(width: MediaQuery.of(context).size.width*0.6,
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(color: Colors.lightGreen,child: Text('Ok',style: TextStyle(color: Colors.white),),onPressed: (){
                  Navigator.pop(context);
                },),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
