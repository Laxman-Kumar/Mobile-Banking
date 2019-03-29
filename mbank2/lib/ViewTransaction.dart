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
        backgroundColor: Color(0xFF424242),

      appBar:PreferredSize(preferredSize: Size.fromHeight(40.0),child:  AppBar(
      title: Text("View Transaction",style: TextStyle(color: Colors.white),),
      backgroundColor: Color(0xFFE64751),
      elevation: 0.0,
      actions: <Widget>[
      ],
     )),

      body:
      Column(
        mainAxisSize: MainAxisSize.max,

        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),

          Row(
            children: <Widget>[

              Expanded(
                flex:1,
                child: Text("Date",style: TextStyle(color: Colors.white),),
              ),

              Expanded( flex:2,
                child: Text("UID",style: TextStyle(color: Colors.white),),
              ),

              Expanded(child: Text("Debit/Credit",style: TextStyle(color: Colors.white),),
                flex:1,
              ),

              Expanded( flex:1,
                child: Text("Current Balance",style: TextStyle(color: Colors.white),),
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
                          Expanded(
                              flex:1,
                              child: Column(
                                children: <Widget>[
                                  Text(formatter.format(data2[index].time) ,style: TextStyle(color: Colors.white),),
                                  Text(formatter2.format(data2[index].time) ,style: TextStyle(color: Colors.white),),
                                ],
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded( flex:2,
                            child: Text(data2[index].uid.substring(1,20),style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded(child: Text(data2[index].amount,style:  TextStyle(color: data[index].type=="Debit"?Colors.redAccent:Colors.green),),
                            flex:1,
                          ),

                          Expanded( flex:1,
                            child: Text(data2[index].currentBal,style: TextStyle(color: Colors.white),),
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
                                color: Colors.white,
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


