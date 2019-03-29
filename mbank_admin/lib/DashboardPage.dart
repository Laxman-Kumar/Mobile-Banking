import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mbank_admin/CreateAccount.dart';
import 'package:mbank_admin/DepositMoney.dart';
import 'package:mbank_admin/ViewCustomers.dart';
import 'package:mbank_admin/WithdrawMoney.dart';
import 'package:mbank_admin/SearchUser.dart';
import 'package:mbank_admin/ChangePhone.dart';



class dashboard extends StatefulWidget{

  dashboard({Key key}) : super(key: key,);
  @override
  _dashboard createState() => new _dashboard();
}

class _dashboard extends State<dashboard>{


  @override
  void initState(){
    // TODO: implement initState

    super.initState();
  }

  @override
  void didUpdateWidget(dashboard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.black54,


        appBar:  AppBar(
          title: Text("mBank Admin Dashboard",style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFFE64751),
          elevation: 0.0,
          actions: <Widget>[
          ],
        ),



        body:SingleChildScrollView(child:
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              alignment: Alignment.center,
              child: Text("Welcome to mBank",style: TextStyle(fontSize: 26,color: Colors.white),),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
            ),

            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Container(
                  height: 80,
                  color: Color(0xFF154360),
                  child: Image.asset("assests/create.png",color: Colors.white,),
                ),

                Expanded(
                    child: Container(
                      height: 80,
                      child: FlatButton(
                        highlightColor: Colors.black38,
                        onPressed: createAccount,
                        textColor: Colors.white,
                        color: Color(0xFF2471A3),
                        child: new Text("Create Bank Account",style: TextStyle(fontSize: 20)),
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

                Container(
                  padding: EdgeInsets.all(4.0),
                  height: 80,
                  color: Color(0xFF196F3D),
                  child: Image.asset("assests/deposit.png",color: Colors.white,),
                ),
                Expanded(
                    child: Container(
                      height: 80,
                      child: FlatButton(onPressed: depositMoney,
                        highlightColor: Colors.black38,
                        textColor: Colors.white,
                        color: Color(0xFF1E8449),
                        child: new Text("Deposit Money",style: TextStyle(fontSize: 20)),

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
                Container(
                  height: 80,
                  color:Color(0xFF935116),
                  child: Image.asset("assests/withdraw.png",color: Colors.white,),
                ),
                Expanded(
                    child: Container(
                      height: 80,
                      child: FlatButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>WithdrawMoney()),
                        );
                      },highlightColor: Colors.black38,
                        textColor: Colors.white,
                        color: Color(0xFFEB984E),
                        child: new Text("Withdraw Money",style: TextStyle(fontSize: 20)),

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
                Container(
                  height: 80,
                  padding: EdgeInsets.all(4.0),
                  color: Color(0xFF5B2C6F),
                  child: Image.asset("assests/view.png",color: Colors.white,),
                ),
                Expanded(
                    child: Container(
                      height: 80,
                      child: FlatButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>ViewCustomers()),
                        );

                      },highlightColor: Colors.black38,
                        textColor: Colors.white,
                        color: Color(0xFF7D3C98),
                        child: new Text("View Customers",style: TextStyle(fontSize: 20)),

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
                Container(
                  height: 80,
                  color: Color(0xFF7B241C),
                  child: Image.asset("assests/phone.png",color: Colors.white,),
                ),
                Expanded(
                    child: Container(
                      height: 80,
                      child: FlatButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>ChangePhone()),
                        );

                      },highlightColor: Colors.black38,
                        textColor: Colors.white,
                        color: Color(0xFFC0392B),
                        child: new Text("Change phone number",style: TextStyle(fontSize: 20)),

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
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: 80,
                  color: Color(0xFF21618C),
                  child: Image.asset("assests/search.png",color: Colors.white,),
                ),
                Expanded(
                    child: Container(
                      height: 80,
                      child: FlatButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>SearchUser()),
                        );

                      },highlightColor: Colors.black38,
                        textColor: Colors.white,
                        color: Color(0xFF2E86C1),
                        child: new Text("Search user",style: TextStyle(fontSize: 20)),

                      ),

                    )),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(top: 40),
            ),
            Container(
              child: Text("© Copyright Laxman Kumar",style: TextStyle(fontSize: 20,color: Colors.white70),),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
          ],
        )
    ));

  }



  void createAccount(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>AddingData()),
    );
  }
  void depositMoney(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>CreateTransaction()),
    );
  }
}