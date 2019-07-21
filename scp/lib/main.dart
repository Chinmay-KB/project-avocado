import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scp/booking.dart';
import 'package:scp/cards.dart';
import 'package:scp/login.dart';
import 'package:scp/gradients.dart';
import 'package:scp/appointments.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:scp/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timetable/theorySection.dart';


import 'package:scp/time_table.dart';

var firebaseInstance=FirebaseAuth.instance;
void main()=>runApp(
      MaterialApp(
        title: 'SCP Demo',
        routes: <String, WidgetBuilder>{
          '/homePage': (BuildContext context) => HomePage(title: 'SCP Home Page'),
          '/loginPage': (BuildContext context) => Login(),
          '/appointments': (BuildContext context) => Appointments(),
          '/timetable':(BuildContext context)=> TheorySection(),
          '/userdata':(BuildContext context)=>Userdata(),
          '/login':(BuildContext context)=>Login(),
          '/booking': (BuildContext context) => Booking(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyApp(),
      ));

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      //statusBarColor: Colors.white70, //or set color with: Color(0xFF0000FF)
    //));
    return _handleCurrentScreen();
  }
}

Widget _handleCurrentScreen() {
  return new StreamBuilder<FirebaseUser>(
      stream: firebaseInstance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Login();
        } else {
          if (snapshot.hasData) {
            return Userdata();
          }
          else{
            return Login();
          }
        }
      });
}

class HomePage extends StatefulWidget {

  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String username=" ";
  String roll_no=" ";
  String phone_no=" ";
  static const platform=const MethodChannel("FAQ_ACTIVITY");
  @override
  Widget build(BuildContext context) {
    Gradients().init(context);
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    var queryWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      drawer: Drawer(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DrawerHeader(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(username,
                style: TextStyle(
                  fontFamily: 'PfDin',
                  fontSize: 20.0
                )),
                  Text(phone_no,
                    style: TextStyle(
                        fontFamily: 'PfDin',
                    ),),
                  Text(roll_no,
                    style: TextStyle(
                        fontFamily: 'PfDin',
                    ),)
              ],))
            ],
        )
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title:Text(
          'SCP',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'PfDin',
              letterSpacing: 2),
        ) ,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          appointmentCard(context, queryWidth, textScaleFactor),
          InkWell(
            onTap:()=> _startFAQActivity(),
              child: faqCard(context, queryWidth, textScaleFactor)),
          mentorsCard(context, queryWidth, textScaleFactor),
          timetableCard(context, queryWidth, textScaleFactor)
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    fetchUserData(context);
  }

  Future fetchUserData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username= prefs.getString('username');
    roll_no=prefs.getString('roll_no');
    phone_no=prefs.getString('phone_no');
  }


  _startFAQActivity() async{
    try {
      await platform.invokeMethod('startFaqActivity');
    } on PlatformException catch (e){
      print(e.message);
    }
  }
}
