import 'package:encrypt/encrypt.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mbank2/globals.dart';
import 'package:flutter/services.dart';
import 'package:mbank2/controller/registrationClass.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mbank2/registration.dart';

class Scanning extends StatefulWidget{
  Scanning({Key key}) : super(key: key);

  @override
  _Scanning createState() => new _Scanning();

}

class _Scanning extends State<Scanning> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final key = 'private!!!!!!!!!';
  final iv = '8bytesiv';

  List<String> dataSetPhone = [];
  List<String> dataSetAccount = [];

  TextEditingController phone= new TextEditingController();
  TextEditingController account= new TextEditingController();

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    phone.clear();
    account.clear();
    super.dispose();
  }

  void cancel(){
    Navigator.pop(context);
  }
  Future<void> checkingForInfo() async {
    final encrypter =new Encrypter(new Salsa20(key, iv));
    DatabaseReference db = FirebaseDatabase.instance.reference();

   await db.child('account_details').once().then((DataSnapshot snapshot){
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      print(keys);
      for (var key in keys){
        var x = encrypter.decrypt(data[key]['Account_no']);
        print(x);
        dataSetAccount.add(x);
        dataSetPhone.add(encrypter.decrypt(data[key]['Phone_no']));
      }
    });
  }

@override
  void initState(){
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFF424242),
        body: SingleChildScrollView(
            child: new ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 672),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.fromLTRB(0, 90,0, 0),

                      child: new Row(
                        children: <Widget>[
                          Expanded(
                              child: Text("Check for Account",textAlign: TextAlign.center,style:TextStyle(fontSize: 30,color: Colors.redAccent,fontFamily:'mukta'),)
                          )
                        ],),),
                    Container(

                        child:  new Container(
                            padding: EdgeInsets.only(top: 30),
                            width: 280,
                            color: Colors.transparent,
                            child: new Container(
                                decoration:  new BoxDecoration(

                                    color: Colors.white, borderRadius: new BorderRadius.all(Radius.circular(25.0)
                                )),
                                child:Form(key: _formKey,
                                    autovalidate: true,
                                    child: Column(
                                      children: <Widget>[

                                        Container(
                                            padding: EdgeInsets.only(top: 20),
                                            width: 200,
                                            child: TextFormField(
                                              controller: account,
                                              keyboardType: TextInputType.number,
                                              // cursorColor: Color(0xFFA86E52),
                                              validator: (val) => val.isEmpty ? 'Account no is required' : null,
                                              decoration: new InputDecoration(
                                                  focusedBorder: new OutlineInputBorder(
                                                    borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                  ),
                                                  border: new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Color.fromRGBO(
                                                            246, 242, 199, 1.0)),
                                                    borderRadius: const BorderRadius
                                                        .all(
                                                      const Radius.circular(15.0),),
                                                  ),
                                                  filled: true,
                                                  hintStyle: new TextStyle(
                                                      color: Colors.white),
                                                  hintText: "Account Number",
                                                  fillColor: Color(0xFF757575)),
                                            )
                                        ),

                                        Container(
                                            padding: EdgeInsets.only(top: 10),
                                            width: 200,
                                            child: TextFormField(
                                              controller: phone,
                                              //cursorColor: Color(0xFFA86E52),
                                              validator: (val) => val.length<10 ? 'Phone number should be correct' : null,
                                              keyboardType: TextInputType.phone,
                                              decoration: new InputDecoration(
                                                  focusedBorder: new OutlineInputBorder(
                                                    borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                                    borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                                  ),
                                                  border: new OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Color.fromRGBO(
                                                            246, 242, 199, 1.0)),
                                                    borderRadius: const BorderRadius
                                                        .all(
                                                      const Radius.circular(15.0),),
                                                  ),
                                                  filled: true,
                                                  hintStyle: new TextStyle(
                                                      color: Colors.white),
                                                  hintText: "Phone Number",
                                                  fillColor: Color(0xFF757575)),
                                            )
                                        ),

                                        Container(
                                          width: 150,
                                          height: 70,
                                          padding: EdgeInsets.only(top: 20),
                                          margin: EdgeInsets.only(bottom: 20),
                                          child: RaisedButton(onPressed: registerPage,
                                              elevation: 0.0,
                                              color: Colors.red,
                                              textColor: Colors.white,

                                              child: new Text("Check for Account",style: TextStyle(fontSize: 14)),
                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                          ),)

                                      ],


                                    ))))),
                  ]),


            )));



  }



  void registerPage() async {

    final FormState form = _formKey.currentState;
    var nav = context;
    if(form.validate()){
    showMessage("We are checking for the details",Colors.green);
      await checkingForInfo();
      form.save();
      if(dataSetPhone.contains(phone.text) && dataSetAccount.contains(account.text)){
        accountDetail = account.text;
        phoneDetail= phone.text;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Registration()),);
      }
      else{
        showDialog(context: nav,builder: (BuildContext context){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Your account no or phone no is wrong"),
            actions: <Widget>[
              FlatButton(
                child:  Text("Close"),
                onPressed: (){Navigator.of(context).pop();},
              )
            ],
          );
        });
      }
    }
    else{
      showDialog(context: nav,builder: (BuildContext context){
        return AlertDialog(
          title: Text("Error"),
          content: Text("Please enter the details"),
          actions: <Widget>[
            FlatButton(
              child:  Text("Close"),
              onPressed: (){Navigator.of(context).pop();},
            )
          ],
        );
      });
    }
  }


}
