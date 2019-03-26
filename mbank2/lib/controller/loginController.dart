import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mbank2/dashboard.dart';
import 'package:mbank2/admin/CreateTransaction.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Log{

  var email;
  var password;
  var nav;

  Log( var email,var password,var nav)
  {
    this.email = email;
    this.password=password;
    this.nav=nav;

  }

  Future<bool> checkingForInfo(String uid) async {
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';

    final encrypter =new Encrypter(new Salsa20(key, iv));
    DatabaseReference db = FirebaseDatabase.instance.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();

   await db.child('registered_data').once().then((DataSnapshot snapshot){
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      print(keys);
      for (var key in keys){
        var x = data[key]['uid'];
        if (x==uid) {
          print("Phone is : " + encrypter.decrypt(data[key]['Phone_no']));
          prefs.setString('phone', encrypter.decrypt(data[key]['Phone_no']));
          prefs.setString('account', encrypter.decrypt(data[key]['Account_no']));
        }

      }
    });
   return true;
  }


  void log() async {
    try{

      FirebaseUser user=await FirebaseAuth.instance.currentUser();
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
      await user.reload();
      user = await FirebaseAuth.instance.currentUser();
      bool flag = user.isEmailVerified;

      await checkingForInfo(user.uid);
      print(user.uid.toString());


      if(flag)
      {
       // FirebaseUser user=await FirebaseAuth.instance.currentUser();
      //  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);

        Navigator.pushReplacement(nav, MaterialPageRoute(builder: (context) => dashboard(user: user)));//(user: user)));

      }
      else
      {
        showDialog(context: nav,builder: (BuildContext context)
        {
          return AlertDialog(
            title: new Text("Verify mail"),
            content: new Text("Please verify your mail before log in"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        );

      }}catch(e){
      print(e.message);
    }
  }
}