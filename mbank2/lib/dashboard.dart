import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mbank2/DownloadinTransactions.dart';
import 'package:mbank2/login.dart';
import 'package:mbank2/ViewTransaction.dart';
import 'package:mbank2/controller/CustomerClass.dart';
import 'package:mbank2/globals.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mbank2/LocateAtm.dart';
import 'package:mbank2/ViewBeneficiary.dart';
import 'package:mbank2/TransferFunds.dart';
import 'package:mbank2/login.dart';

class dashboard extends StatefulWidget{
  FirebaseUser user;
  dashboard({Key key,this.user}) : super(key: key,);
  @override
  _dashboard createState() => new _dashboard();
}

class _dashboard extends State<dashboard>{

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  String currentBalance="0";
  String username="";
  String accountNo="";
  
  Future<void> checkingForInfo() async {
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';
    final encrypter =new Encrypter(new Salsa20(key, iv));
    DatabaseReference db = FirebaseDatabase.instance.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountNo = prefs.getString('account');
    print(accountNo);
    await db.child('account_details').once().then((DataSnapshot snapshot){
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      print(keys);
      for (var key in keys){
        var x = encrypter.decrypt(data[key]['Account_no']);
        if(x == accountNo){
          setState(() {
            currentBalance = encrypter.decrypt(data[key]['Balance']);
          });
        }
      }
    });

   await  db.child('registered_data').once().then((DataSnapshot snapshot){
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      print(keys);
      for (var key in keys){
        var x = encrypter.decrypt(data[key]['Account_no']);
        if(x == prefs.getString("account")){
          setState(() {
            username = encrypter.decrypt(data[key]['Username']);
          });
          print(currentBalance);}
      }
    });

  }

  @override
  void initState(){
    // TODO: implement initState
    setState(() {
      checkingForInfo();
    });


    firebaseCloudMessaging_Listeners();

    super.initState();
  }

@override
  void didUpdateWidget(dashboard oldWidget) {
    // TODO: implement didUpdateWidget
    checkingForInfo();
    super.didUpdateWidget(oldWidget);
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print("tokennnnn is "+token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  Dialog createlogoutDialog() {
    return  Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),
        ),
        //this right here
        child: Container(
          padding: EdgeInsets.all(8.0),
            height: 150.0,
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top:8),
                ),
                Center(
                  child: Text("Are you sure you want to log out !!!",style: TextStyle(fontSize: 22),),
                ),
             
                Padding(
                  padding: EdgeInsets.only(top:8),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 15, right: 15,),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Padding(padding: EdgeInsets.only(bottom: 10),),

                        Row(
                          children: <Widget>[

                            Container(
                              width: 105,
                              height: 45,
                              child: RaisedButton(onPressed:(){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                              },
                                  elevation: 0.0,
                                  color: Color(0xFFbf2b46),
                                  textColor: Colors.white,
                                  child: new Text("Logout",style: TextStyle(fontSize: 12)),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                              ),
                            ),

                            Padding(padding: EdgeInsets.only(left: 10),),

                            Container(
                              width: 105,
                              height: 45,
                              child:RaisedButton(onPressed: (){ Navigator.pop(context);},
                                  elevation: 0.0,
                                  color:  Color(0xFFbf2b46),
                                  textColor: Colors.white,
                                  child: new Text("Cancel",style: TextStyle(fontSize: 12)),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                              ),
                            )


                          ],
                        )


                      ],
                    )
                ),

              ],
            ))

    );
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor:Colors.white,


        appBar:  AppBar(
          title: Text("Dashboard",style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFFbf2b46),
          elevation: 3.0,
          actions: <Widget>[

            IconButton(
              icon: ImageIcon(AssetImage('assests/logout.png'),size :21),
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context) => createlogoutDialog());
              },
            ),

          ],
        ),



        body: SingleChildScrollView(child:
        Column(
         mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8),
          ),

            Row(
              children: <Widget>[


                Expanded(

                  child: Container(
                      decoration: BoxDecoration(
                        // Box decoration takes a gradient
                       color: Color(0xFF03A9F4),
                      ),

                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                        ),
                        Container(
                          child: Text("Welcome "+username,style: TextStyle(fontSize: 24,color: Colors.white),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 6),
                          child: Text("Account No "+accountNo,style: TextStyle(fontSize: 16,color: Colors.black),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 6),
                          child: Text("Current Balance "+currentBalance,style: TextStyle(fontSize: 16,color:Colors.black),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.0),
                        ),
                      ],

                    )
                  ),
                ),
              ],

            ),



          Padding(
            padding: EdgeInsets.only(top: 18),
          ),
          Row(
            children: <Widget>[

              Expanded(
                  child: Container(
                    height: 60,
                    child: FlatButton(onPressed: viewTransaction,
                      textColor: Colors.white,
                      color:  Color(0xFFbf2b46),
                      child: new Text("View Transactions",style: TextStyle(fontSize: 18)),

                    ),

                  )),
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),

              Expanded(
                  child: Container(
                    height: 60,
                    child: FlatButton(onPressed: downTransaction,
                      textColor: Colors.white,
                      color: Color(0xFFbf2b46),
                      child: new Text("Download Transactions",style: TextStyle(fontSize: 18)),

                    ),

                  )),

            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),

          Row(
            children: <Widget>[

              Container(
                padding: EdgeInsets.all(4.0),
                height: 60,
                color: Color(0xFF154360),
                child: Image.asset("assests/add_bene.png",color: Colors.white,),
              ),
              Expanded(
                  child: Container(
                    height: 60,

                    child: FlatButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => ViewBeneficiary()));},
                      textColor: Colors.white,highlightColor: Colors.black38,color: Color(0xFF2471A3),
                      child: new Text("Add/Manage Beneficiary",style: TextStyle(fontSize: 18)),

                    ),

                  )),

            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 10),
          ),


          Row(
            children: <Widget>[
              Container(
                height: 60,
                color:Color(0xFF154360),
                child: Image.asset("assests/transfer.png",color: Colors.white,),
              ),
              Expanded(
                  child: Container(
                    height: 60,
                    child: FlatButton(onPressed: (){  Navigator.push(context, MaterialPageRoute(builder: (context) => TransferMoney()));},
                      textColor: Colors.white,highlightColor: Colors.black38,
                      color: Color(0xFF2471A3),
                      child: new Text("Transfer money",style: TextStyle(fontSize: 20)),

                    ),

                  )),

            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 10),
          ),


          Row(
            children: <Widget>[
               Container(
                height: 60,
                color:Color(0xFF154360),
                child: Image.asset("assests/locate.png"),
              ),
              Expanded(
                  child: Container(
                    height: 60,
                    child: FlatButton(onPressed: (){  Navigator.push(context, MaterialPageRoute(builder: (context) => LocateAtm()));},
                      textColor: Colors.white,highlightColor: Colors.black38,
                      color: Color(0xFF2471A3),
                      child: new Text("Locate ATM",style: TextStyle(fontSize: 20)),

                    ),

                  )),

            ],
          ),



          Padding(
            padding: EdgeInsets.only(top: 10),
          ),

          Row(
            children: <Widget>[

              Container(
                padding: EdgeInsets.all(4.0),
                height: 60,
                color: Color(0xFF154360),
                child: Image.asset("assests/deposit.png",color: Colors.white,),
              ),
              Expanded(
                  child: Container(
                    height: 60,

                    child: FlatButton(onPressed: (){},
                      textColor: Colors.white,highlightColor: Colors.black38,color: Color(0xFF2471A3),
                      child: new Text("Change phone number",style: TextStyle(fontSize: 20)),

                    ),

                  )),

            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 10),
          ),

          Row(
            children: <Widget>[

              Container(
                height: 60,
                color: Color(0xFF154360),
                child: Image.asset("assests/change_pass.png",color: Colors.white,),
              ),
              Expanded(
                  child: Container(
                    height: 60,

                    child: FlatButton(onPressed: (){},
                      textColor: Colors.white,highlightColor: Colors.black38,color: Color(0xFF2471A3),
                      child: new Text("Change password",style: TextStyle(fontSize: 20)),

                    ),

                  )),

            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 10),
          ),

            Container(

              child: Text("© Copyright ICT GNU",style: TextStyle(fontSize: 16)),
            ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          ],
        ))
    );

  }

  void createTransaction(){


  }

  void viewTransaction(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTransaction()));

  }

  _write(String text) async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    final file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
  }
  void downTransaction(){

    _write("Hello There");


  }


}