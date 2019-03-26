import 'package:flutter/material.dart';
import 'package:mbank2/admin/CreateTransaction.dart';
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
      collectinDataForTransaction();
    });


    firebaseCloudMessaging_Listeners();

    super.initState();
  }

@override
  void didUpdateWidget(dashboard oldWidget) {
    // TODO: implement didUpdateWidget
    checkingForInfo();
    collectinDataForTransaction();
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
  void choicesSecond(choice) async{

    if(choice=='2'){
      print(choice.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    }
    if(choice=='1'){
      print(choice.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateTransaction()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color(0xFF424242),


        appBar:PreferredSize(preferredSize: Size.fromHeight(40.0),child:  AppBar(
          title: Text("Dashboard",style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFFE64751),
          elevation: 0.0,
          actions: <Widget>[

            new PopupMenuButton(
                icon:Icon(Icons.settings,color: Colors.white,size: 20,),
                tooltip: 'settings',
                onSelected: choicesSecond,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[

                  PopupMenuItem(value: "1", child: Row(children: <Widget>[
                    Expanded(flex: 1, child:Image.asset("assests/add.png",color: Colors.redAccent,width: 30,height: 30,)),
                    Expanded(flex: 1,child: Container(),),
                    Expanded(flex: 4, child: Text("Create Transaction",style: TextStyle (color:Colors.redAccent ),),)],),),

                  PopupMenuDivider(height: 20),

                  PopupMenuItem(value: "2", child: Row(children: <Widget>[
                    Expanded(flex: 1, child:Image.asset("assests/shutdown.png",width: 30,height: 30,color: Colors.redAccent,)),
                    Expanded(flex: 1,child: Container(),),
                    Expanded(flex: 4, child: Text("Log out",style: TextStyle (color:Colors.redAccent ),),)],),),

                ]),
          ],
        )),



        body: Column(
         mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
            Container(
            child: Text("Welcome "+username.toUpperCase(),style: TextStyle(fontSize: 26,color: Colors.white),),
            ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text("Account No "+accountNo,style: TextStyle(fontSize: 18,color: Colors.white),),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text("Current Balance "+currentBalance,style: TextStyle(fontSize: 18,color: Colors.white),),
          ),

          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),
              Expanded(
                  child: Container(
                    height: 80,
                    child: FlatButton(onPressed: viewTransaction,
                      textColor: Colors.white,
                      color: Colors.redAccent,
                      child: new Text("View Transactions",style: TextStyle(fontSize: 20)),

                    ),

                  )),
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),

              Expanded(
                  child: Container(
                    height: 80,
                    child: FlatButton(onPressed: downTransaction,
                      textColor: Colors.white,
                      color: Colors.redAccent,
                      child: new Text("Download Transactions",style: TextStyle(fontSize: 20)),

                    ),

                  )),
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),

          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),
              Expanded(
                  child: Container(
                    height: 80,
                    child: FlatButton(onPressed: (){},
                      textColor: Colors.white,
                      color: Colors.redAccent,
                      child: new Text("Locate ATM",style: TextStyle(fontSize: 20)),

                    ),

                  )),
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),
            ],
          ),

          Expanded(
            child: Container(),
          )  ,
            Container(
              child: Text("© Copyright Laxman Kumar",style: TextStyle(fontSize: 20,color: Colors.white70),),
            ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          ],
        )
    );

  }

  void createTransaction(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateTransaction()));//(user: user)));

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

 Future<void> collectinDataForTransaction() async{

    data.clear();
    // List<CustomerClass> dataObj=[];
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';

    final encrypter =new Encrypter(new Salsa20(key, iv));
    DatabaseReference db = FirebaseDatabase.instance.reference();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountNo = prefs.getString('account');

    List<String> keyList =[];
    await db.child('Transaction_Details').child(accountNo).once().then((DataSnapshot snapshot){
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      print(keys);
      for (var key in keys) {
        keyList.add(key);
      }
    });

    print("length"+keyList.length.toString());
    setState(() {
      lengthData = keyList.length;
    });

    for (int i=0;i<keyList.length;i++) {
      List<String> dd = [];

      await db.child('Transaction_Details').child(accountNo)
          .child(keyList[i])
          .once()
          .then((DataSnapshot snapshot) {
        var keys = snapshot.value.keys;
        var data = snapshot.value;
        for ( var key1 in keys ) {
          var t1 = data[key1];
          dd.add(t1.toString());
        }
      });
      CustomerClass obj = CustomerClass(time: DateTime.parse(dd[3]), type: dd[1], currentBal: dd[5], amount: dd[2], uid: dd[0]);

        data.add(obj);


    }
   // return dataObj;
  }

}