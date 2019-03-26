import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mbank2/login.dart';
class AddingData extends StatefulWidget{
  AddingData({Key key}) : super(key: key);

  @override
  _AddingData createState() => new _AddingData();

}

class _AddingData extends State<AddingData> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autovalidate =false;

  TextEditingController phone= new TextEditingController();
  TextEditingController balance= new TextEditingController();
  TextEditingController account= new TextEditingController();


  void cancel(){
    Navigator.pop(context);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    phone.clear();
    balance.clear();
    account.clear();
    super.dispose();
  }

  void showMessage(String message, MaterialColor color ) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
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
                              child: Text("Account Details Adding",textAlign: TextAlign.center,style:TextStyle(fontSize: 30,color: Colors.redAccent,fontFamily:'mukta'),)
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
                                    autovalidate: _autovalidate,
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
                                            padding: EdgeInsets.only(top: 10),
                                            width: 200,
                                            child: TextFormField(
                                              controller: balance,
                                              //cursorColor: Color(0xFFA86E52),
                                              validator: (val) => val.length==0? 'Enter Balance' : null,
                                              keyboardType: TextInputType.number,
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
                                                  hintText: "Initial Balance",
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
                                              color:Colors.redAccent,
                                              textColor: Colors.white,

                                              child: new Text("ADD",style: TextStyle(fontSize: 14)),
                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                          ),)

                                      ],


                                    ))))),
                  ]),


            )));



  }


  void registerPage() async {
    var uuid = new Uuid();
    final FormState form = _formKey.currentState;
    //final key = 'my32lengthsupersecretnooneknowsl';
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';

    final encrypter =new Encrypter(new Salsa20(key, iv));


    final encryptedPhone = encrypter.encrypt(phone.text);
    final encryptedAccount = encrypter.encrypt(account.text);
    final encryptedBalance = encrypter.encrypt(balance.text);

    if(form.validate()){
      showMessage('Adding Data.... Please Wait',Colors.green);
     DatabaseReference db = FirebaseDatabase.instance.reference();
     await db.child("account_details").child(uuid.v1()).set({
        'Phone_no': encryptedPhone,
        'Account_no': encryptedAccount,
        'Balance': encryptedBalance,
      });
      print(phone.text);

      Navigator.push(
       context, MaterialPageRoute(builder: (context) =>Login()),
     );

    }else{
      showMessage('Data entered is not correct',Colors.red);
    }





  }




}
