import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mbank_admin/DashboardPage.dart';
class CreateTransaction extends StatefulWidget{
  CreateTransaction({Key key}) : super(key: key);

  @override
  _CreateTransaction createState() => new _CreateTransaction();

}

class _CreateTransaction extends State<CreateTransaction> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String keyUpdate;
  TextEditingController accountno= new TextEditingController();
  TextEditingController balance= new TextEditingController();
  TextEditingController deposited= new TextEditingController();


  List _lan = ["Aburoad","Ahmedabad","Banglore","Mumbai"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentlan;

  String lan;
  String branch;
  String currentBalance;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String language in _lan) {
      items.add(new DropdownMenuItem(
          value: language,
          child: new Text(language)
      ));
    }
    return items;
  }

  void cancel(){
    Navigator.pop(context);
  }


  Future<void> checkingForInfo() async {
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';
    final encrypter =new Encrypter(new Salsa20(key, iv));
    DatabaseReference db = FirebaseDatabase.instance.reference();

    await db.child('account_details').once().then((DataSnapshot snapshot){
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      print(keys);
      for (var key in keys){
        var x = encrypter.decrypt(data[key]['Account_no']);
        var y = encrypter.decrypt(data[key]['Branch']);
        if(x == accountno.text && y == _currentlan){
          keyUpdate =key ;
          currentBalance = encrypter.decrypt(data[key]['Balance']);
        }
      }});


  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF424242),

      appBar: AppBar(
        title: Text("Deposit Money",style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFFE64751),
        elevation: 0.0,),


      body: SingleChildScrollView(child:
      Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            Container(
              margin: EdgeInsets.only(top: 40)
              ,child: new Row(
                children: <Widget>[
                  Expanded(
                      child: Text("Deposit your money here",textAlign: TextAlign.center,style:TextStyle(fontSize: 30,color: Colors.white,fontFamily:'mukta'),)
                  )
                ],),),

            Container(

                child:  new Container(
                    margin: EdgeInsets.only(top: 20),
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
                                    padding: EdgeInsets.only(top: 10),
                                    width: 200,
                                    child: TextFormField(style: TextStyle(color: Colors.white),
                                      controller: accountno,
                                      //cursorColor: Color(0xFFA86E52),
                                      keyboardType: TextInputType.number,
                                      decoration: new InputDecoration(
                                          focusedBorder: new OutlineInputBorder(
                                            borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                            borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                          ),
                                          border: new OutlineInputBorder(
                                            borderSide: new BorderSide(color: Color.fromRGBO(246, 242, 199, 1.0)),
                                            borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                          ),
                                          filled: true,
                                          hintStyle: new TextStyle(color: Colors.white),
                                          hintText: "Enter Account no",
                                          fillColor: Color(0xFF757575)),
                                    )
                                ),



                                Container(
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.only(left: 10),
                                    width: 200,
                                    decoration:  new BoxDecoration(
                                        color: Color(0xFF757575),
                                        border: Border.all(color:Color.fromRGBO(246,242,199, 1.0),),
                                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                                    ),
                                    child: DropdownButton(
                                      hint: Text("Select Branch"),
                                      value: _currentlan,
                                      items: _dropDownMenuItems,
                                      onChanged: changedDropDownItem,
                                      style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.normal),
                                      isExpanded: true,
                                      elevation: 12,
                                      iconSize: 42,
                                    )
                                ),
                                /*
                                Container(
                                    padding: EdgeInsets.only(top: 20),
                                    width: 200,
                                    child: TextFormField(style: TextStyle(color: Colors.white),
                                      controller: deposited,
                                      //cursorColor: Color(0xFFA86E52),
                                      decoration: new InputDecoration(
                                          focusedBorder: new OutlineInputBorder(
                                            borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                            borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                          ),
                                          border: new OutlineInputBorder(
                                            borderSide: new BorderSide(color: Color.fromRGBO(246, 242, 199, 1.0)),
                                            borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                          ),
                                          filled: true,
                                          hintStyle: new TextStyle(color: Colors.white),
                                          hintText: "Deposit by",
                                          fillColor: Color(0xFF757575)),
                                    )
                                ),
                                */
                                Container(
                                    padding: EdgeInsets.only(top: 20),
                                    width: 200,
                                    child: TextFormField(
                                      controller:balance,style: TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.number,
                                      //cursorColor: Color(0xFFA86E52),
                                      decoration: new InputDecoration(
                                          focusedBorder: new OutlineInputBorder(
                                            borderSide: new BorderSide(color: Color(0xFFA86E52)),
                                            borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                          ),
                                          border: new OutlineInputBorder(
                                            borderSide: new BorderSide(color: Color.fromRGBO(246, 242, 199, 1.0)),
                                            borderRadius: const BorderRadius.all(const Radius.circular(15.0),),
                                          ),
                                          filled: true,
                                          hintStyle: new TextStyle(color: Colors.white),
                                          hintText: "Amount",
                                          fillColor: Color(0xFF757575)),
                                    )
                                ),

                                Container(
                                  width: 150,
                                  height: 70,
                                  padding: EdgeInsets.only(top: 20),
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: RaisedButton(onPressed: createTrans,
                                      elevation: 0.0,
                                      color: Colors.redAccent,
                                      textColor: Colors.white,

                                      child: new Text("Deposit",style: TextStyle(fontSize: 14)),
                                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                  ),)

                              ],


                            ))))),
          ]),


      ) );



  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentlan = selectedCity;
      lan=_currentlan;
      print(lan);
    });
  }
  void showMessage(String message, MaterialColor color) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }


  void createTrans() async{
    var uuid = new Uuid();
    final key = 'private!!!!!!!!!';
    final iv = '8bytesiv';
    int newBalance;

    final encrypter =new Encrypter(new Salsa20(key, iv));

    await checkingForInfo();
    Future.delayed(Duration(seconds: 5), );

     if(keyUpdate!=null) {

       showMessage("Transaction is in process........", Colors.green);
       newBalance = int.parse(currentBalance) + int.parse(balance.text);
       currentBalance = newBalance.toString();

       String uid = uuid.v1();

       print("Balance" + newBalance.toString());
       print("Time" + DateTime.now().toString());

       DatabaseReference db = FirebaseDatabase.instance.reference();

       await db.child("Transaction_Details").child(accountno.text).child(uid).set({
         "Uid": uid,
         "Transaction_amount": balance.text,
         "Current_Balance": newBalance,
         "Time": DateTime.now().toString(),
         "Type":"Credit",
       });

       await db.child('account_details').child(keyUpdate).update(
           {"Balance": encrypter.encrypt(newBalance.toString())});

       Future.delayed(Duration(seconds: 2), );
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) => dashboard()),
       );
     }else{

       showMessage("The account no entered does not exist. Please check account no or branch.", Colors.red);
     }


  }


  @override
  void dispose() {
    // TODO: implement dispose
    balance.clear();
    accountno.clear();
    deposited.clear();
    super.dispose();
  }

}
