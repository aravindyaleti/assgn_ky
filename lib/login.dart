
import 'package:assgn_ky/main.dart';
import 'package:assgn_ky/models/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String mail;
  String pass;
  FirebaseUser _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,children: [
      SizedBox(height: 60,),
      Center(child: Text("Authentication",style: GoogleFonts.poppins(fontSize: 32))),
      SizedBox(height: 30,),
      Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 32,right: 32,bottom: 8,top: 8),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.text,
                validator: (String arg) {
                  if(arg.length < 8)
                    return 'Please enter a valid mail address*';
                  else
                    return null;
                },
                onSaved: (String val) {
                  mail = val;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32,right: 32,bottom: 8,top: 8),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Password',border: OutlineInputBorder()),
                keyboardType: TextInputType.text,
                validator: (String arg) {
                  if(arg.length < 6)
                    return 'Password must be more than 6 letters*';
                  else
                    return null;
                },
                onSaved: (String val) {
                  pass = val;
                },
              ),
            ),
            new SizedBox(
              height: 10.0,
            ),
            Container(width: MediaQuery.of(context).size.width*0.8,
              height: 50,
              child: MaterialButton(color: Colors.blue,elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color: Color(0xffffffff))),
                  child: Text(
                      "SignUP",
                      style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18)
                  ),
                  onPressed: _validateInputs
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top: MediaQuery.of(context).size.height*0.02,bottom: 20),
        child: Text('OR',style: TextStyle(color: Color(0xffb1b1b1)),textAlign: TextAlign.center,),
      ),
      SizedBox(height: 10,),
      Container(width: MediaQuery.of(context).size.width*0.8,
        height: 50,
        child: MaterialButton(color: Color(0xfff4f4f4),elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color: Color(0xffffffff))),
            child: Row(mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/search.png',width: 35,height: 35),
                SizedBox(width: 12,),
                Text("Login with google", style: GoogleFonts.poppins(color: Color(0xff313131),fontWeight: FontWeight.normal),),
              ],
            ),
            onPressed: () async{
              signInWithGoogle();
            }
        ),
      ),
    ],),);
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _signIn();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future _signIn()async{
    FirebaseAuth auth=FirebaseAuth.instance;
    try{
      AuthResult authResult=await _auth.createUserWithEmailAndPassword(email: mail.trim(), password: pass.trim());
      userServices.getUser();
      if(authResult.user!=null||userServices.user!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>MyHomePage()));
      }
    }catch(e){

    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    showDialog(context: context,builder: (context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }, barrierDismissible: false);
    try{
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      AuthResult authResult = await _auth.signInWithCredential(credential);
      _user = authResult.user;
      assert(!_user.isAnonymous);
      assert(await _user.getIdToken() != null);
      FirebaseUser currentUser = await _auth.currentUser();
      assert(_user.uid == currentUser.uid);
      userServices.getUser();
      if(userServices.user!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>MyHomePage()));
      }else{

      }
    }catch(e){
      print(e.toString());
    }
  }
}
