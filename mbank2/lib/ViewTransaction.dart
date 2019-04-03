import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mbank2/controller/CustomerClass.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mbank2/globals.dart';
import 'package:intl/intl.dart';


class ViewTransaction extends StatefulWidget{
  FirebaseUser user;
  ViewTransaction({Key key,this.user}) : super(key: key,);

  @override
  _ViewTransaction createState() => new _ViewTransaction();
}

class _ViewTransaction extends State<ViewTransaction>{

  List<CustomerClass> data2;
  @override
  void initState() {
    super.initState();
    setState(() {
      data2 = data;
    });
  }
  var formatter = new DateFormat.yMd();
  var formatter2 = new DateFormat("h:mm a");


  @override
  Widget build(BuildContext context) {
    data.sort((a, b) => a.time.compareTo(b.time));
    return new Scaffold(
        backgroundColor: Colors.white,

      appBar: AppBar(
      title: Text("View Transaction",style: TextStyle(color: Colors.white),),
      backgroundColor: Color(0xFFE64751),
      elevation: 0.0,
      actions: <Widget>[
      ],
     ),

      body:
      Column(
        mainAxisSize: MainAxisSize.max,

        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),

          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Expanded(
                flex:1,
                child: Text("Date"),
              ),

              Expanded( flex:2,
                child: Text("UID"),
              ),

              Expanded(child: Text("Debit/Credit"),
                flex:1,
              ),

              Expanded( flex:1,
                child: Text("Current Balance"),
              ),

            ],
          )
          ,
          Padding(
            padding: EdgeInsets.only(top: 5),
          ),

          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 2,
                  color: Colors.redAccent,
                ),
              )
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 15),
          ),

          Expanded(

            child: new ListView.builder(
                itemCount: data2.length,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: ( context, int index) {
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Expanded(
                              flex:1,
                              child: Column(
                                children: <Widget>[
                                  Text(formatter.format(data2[index].time) ,),
                                  Text(formatter2.format(data2[index].time) ),
                                ],
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Expanded( flex:2,
                            child: Text(data2[index].uid.substring(1,20)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded(child: Text(data2[index].amount,style:  TextStyle(color: data[index].type=="Debit"?Colors.redAccent:Colors.green),),
                            flex:1,
                          ),

                          Expanded( flex:1,
                            child: Text(data2[index].currentBal),
                          ),


                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),

                      Row(
                        children: <Widget>[
                          Expanded(
                              child:Container(
                                height:1,
                                margin: EdgeInsets.only(left: 15,right:15),
                                color: Colors.black26,
                              ))
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 15,right: 10,top: 10),
                      ),
                    ],
                  );


                }
            ,),
          )


        ],

      )
     );
  }




}


