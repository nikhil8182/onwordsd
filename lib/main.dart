import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:onwords/adminHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './DemoHomePage.dart';
import 'Home.dart';
import 'package:after_layout/after_layout.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('emg_ip', "192.168.1.18:8000");
  bool loginCheck=await prefs.get('isLoggedIn');
  String user = await prefs.get('user');
  String ip = await prefs.get('ip');
  String emg_ip = await prefs.get('emg_ip');
  bool check_url = await prefs.get('check_url');
  bool login = await prefs.getBool("login");
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: (login==null)?MyApp():(login==false)?Home(user,ip,check_url):(user=="admin")?adminHome("admin",emg_ip,check_url):MyApp(),
    //home: (first==false)?(user=="admin")?adminHome("admin",emg_ip,check_url):MyApp():Home(user,ip,check_url),
    routes: {
      '/home': (context) => Home(user,ip,check_url),
      '/admin': (context) => adminHome("admin",emg_ip,check_url),
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  bool checkLogInUser;
  Future<bool> update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', emailController.text);
    await prefs.setString('password', passwordController.text);

    return true;
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
  Future<bool> checkuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = await prefs.get('user');
    String pass = await prefs.get('password');
    String ip = await prefs.get('ip');
    bool login = await prefs.get('isLoggedIn');
    emailController.text = user;
    passwordController.text = pass;
    setState(() {
      checkLogInUser=login;
    });
    //print(await prefs.getBool('seen'));
    return true;
  }
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool loading=false;
  bool internet=false;
  bool _validateP = false;
  bool _validateE = false;
  bool pass=true;
  String errortextp;
  String errortexte;


  Future<http.Response> fetchData() async
  {

    try {
      final response = await http.get(Uri.http("34.83.46.202", "/cyberhome/login.php",{"username":"${emailController.text}","password":"${passwordController.text}"}));

      if (response.statusCode == 200) {
        setState(() {
          update();
          //loading = false;
        });
        // If server returns an OK response, parse the JSON.

        if (response.body != '"failed"') {
          String body = response.body.replaceAll('"', '');
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: Colors.black,
                title: Text(
                  "Login Successful",
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                    "Welcome " + response.body.replaceAll('"', ''),
                    style: TextStyle(color: Colors.white)),
              ));

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Home(emailController.text,"",false)),
                (Route<dynamic> route) => false,
          );
        }
        else {
          showDialog( context: context,
              builder: (_) =>
                  AlertDialog(
                    backgroundColor: Colors.black,
                    title: Text(
                      "Login " + response.body.replaceAll( '"', '' ),
                      style: TextStyle( color: Colors.white ), ),
                    content: Text( "Please check the details",
                        style: TextStyle( color: Colors.white ) ), ) );
        }



        return response;
      }
      else {
        setState(() {
          loading = false;
        });
        // If that response was not OK, throw an error.
        throw Exception('Failed to load post');
      }
    }on SocketException {
      /*setState(() {
        loading=false;
        if(internet)
          showDialog(context: context,
              builder: (_) =>
                  AlertDialog(
                      backgroundColor: Colors.black,
                      title: Text("No Response!..",
                        style: TextStyle(color: Colors.white),),
                      content: Text("Slow Server Response or Internet connection",
                        style: TextStyle(color: Colors.white),))
          );
      });*/
      throw Exception('Internet is down');
    }
  }

  Widget _submitButton() {
    /*return InkWell(
      //borderRadius: BorderRadius.all(Radius.circular(10)),
        onTap:()        {
          FocusScope.of(context).requestFocus(new FocusNode());
          check().then((intenet) {
            if (intenet) {
              // Internet Present Case
              setState(() {
                internet=true;
              });
              //print("Connection: present");
              // print(internet);
            }
            else {
              setState(() {
                internet=false;
              });
              //   print("Connection: not present");
              //   print(internet);
            }
            // No-Internet Case
          });
          setState(() {
            emailController.text.isEmpty ? _validateE = true : _validateE = false;
            passwordController.text.isEmpty ? _validateP = true : _validateP = false;
          });
          if(_validateP==false&&_validateE==false&&internet==true) {
            loading = true;
            if(emailController.text=="admin" && passwordController.text=="admin"){
              update();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => adminHome(emailController.text,"",true)),
                    (Route<dynamic> route) => false,

              );

            }
            else{
              update();
              fetchData();
            }

            //get_Ip(emailController.text);
            setState(() {
              errortextp=null;
              errortexte=null;
            });
          }
          else {
            setState(() {
              if(_validateP==true)
                errortextp = 'Password cannot be empty';
              if(_validateE==true)
                errortexte = 'Username or Email cannot be empty';
            });
          }
        },
        child:Container(
          margin: const EdgeInsets.only(left:30,right:30),
          width: MediaQuery.of(context).size.width*0.3,
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,

          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.grey[900],
                  Colors.grey[850],
                  Colors.grey[900],
                ]
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(
            'Login',
            style: GoogleFonts.robotoSlab(fontSize: 18,color: Colors.white),
          ),
        ));*/
    return InkWell(

        onTap:()      async  {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            emailController.text.isEmpty ? _validateE = true : _validateE = false;
            passwordController.text.isEmpty ? _validateP = true : _validateP = false;
          });
          if(_validateP==false&&_validateE==false&&internet==true) {
            if(emailController.text=="admin" && passwordController.text=="admin"){
              update();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => adminHome(emailController.text,"",true)),
                    (Route<dynamic> route) => false,

              );

            }
            else{
              update();
              fetchData();
            }

            //get_Ip(emailController.text);
            setState(() {
              errortextp=null;
              errortexte=null;
            });
          }
          else {
            setState(() {
              if(_validateP==true)
                errortextp = 'Password cannot be empty';
              if(_validateE==true)
                errortexte = 'Username or Email cannot be empty';
            });
          }
        },
        child:Container(
          margin: const EdgeInsets.only(left:30,right:30),
          width: MediaQuery.of(context).size.width*0.3,
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,

          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.grey[900],
                  Colors.grey[850],
                  Colors.grey[900],
                ]
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(
            'Login',
            style: GoogleFonts.robotoSlab(fontSize: 18,color: Colors.white),
          ),
        ));
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        //Text("Login",style: GoogleFonts.robotoSlab(fontSize: 20),),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                  style: TextStyle(color: Colors.black),
                  onTap: () {
                    errortexte = null;
                  },
                  controller: emailController,
                  obscureText: false,
                  cursorColor: Colors.grey[900],
                  decoration: InputDecoration(
                    //labelText: 'Enter the Value',
                    errorText: _validateE ? errortexte : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    prefixIcon: Container(
                      child: Icon(Icons.account_circle,color: Colors.white,size: MediaQuery.of(context).size.height*0.05,),
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.grey[900],
                              Colors.grey[850],
                              Colors.grey[900],
                            ]
                        ),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),
                      ),
                    ),
                    hintText: "Username",
                    hintStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.white,
                    filled: true,
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                  )),

            ],
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                  cursorColor: Colors.grey[900],
                  style: TextStyle(color: Colors.black),
                  onTap: () {
                    errortextp = null;
                  },
                  controller: passwordController,
                  obscureText: pass,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      prefixIcon: Container(
                        child: Icon(Icons.lock_outline,color: Colors.white,size: MediaQuery.of(context).size.height*0.05,),
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  Colors.grey[900],
                                  Colors.grey[850],
                                  Colors.grey[900],
                                ]
                            ),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8))
                        ),
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.black),
                      errorText: _validateP ? errortextp : null,
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: IconButton(
                        icon: pass==true?Icon(Icons.lock_outline):Icon(Icons.lock_open),
                        onPressed: (){
                          if(pass==true){
                            setState(() {
                              pass=false;
                            });
                          }
                          else{

                            setState(() {
                              pass=true;
                            });
                          }

                        },

                      )
                  ))
            ],
          ),

        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey ,
          resizeToAvoidBottomInset : false,
          backgroundColor: Colors.grey[100],
          body: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        /* HexColor("#614385"),
                        HexColor("#516395")*/
                        Colors.grey[900],
                        Colors.grey[850],
                        Colors.grey[900],
                      ]
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.12,
                      width: MediaQuery.of(context).size.width*0.8,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/onwords2.png'),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: height*0.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                      width: width*0.8,
                      child: Column(
                        children: <Widget>[
                          _emailPasswordWidget(),
                          SizedBox(
                            height: height*0.02,
                          ),
                          _submitButton(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.03,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> DemoHome("test","",false)));
                                  },
                                  child: Text('Demo Login',
                                      style: GoogleFonts.robotoSlab(fontSize: 15)),
                                ),
                                InkWell(
                                  onTap: () async{

                                  },
                                  child: Text('Contact us',
                                      style:GoogleFonts.robotoSlab(fontSize: 15)),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              loading   ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor:  Colors.grey[700],
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Colors.white70),
                  ),
                ),
                color: Colors.black.withOpacity(0.5),
              ):Container(),
              /*!*//*internet  ? Container(
                child: Center(
                  child: AlertDialog(
                    backgroundColor: Colors.black,
                    title: Text(
                      "No Internet", style: TextStyle(color: Colors.white),),
                    content: Text("Please check your Connection",
                        style: TextStyle(color: Colors.white)),
                    actions: <Widget>[
                      Center(
                        child: FlatButton(
                          child: Text("Refresh", style: TextStyle(
                              color: Colors.white),),
                          onPressed: () {
                            check().then((intenet) {
                              if (intenet) {
                                // Internet Present Case
                                setState(() {
                                  internet = true;
                                });
                                // print("Connection: present");
                                // print(internet);
                              }
                              else {
                                setState(() {
                                  internet=false;
                                  loading=false;
                                });
                                //print("Connection: not present");
                                //print(internet);
                              }
                              // No-Internet Case
                            });

                            //  Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                color: Colors.white.withOpacity(0.2),
              ):Container()*/
            ],
          )),
    );
  }
  first() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('login',true);
}
  @override
  void initState() {
    first();
    check().then((intenet) {
      if (intenet) {
        // Internet Present Case
        setState(() {
          internet = true;
        });
        //print("Connection: present");
        //print(internet);
        checkuser().then((value) {
          if (emailController.text != "" && passwordController != "" && checkLogInUser==false)
            fetchData();
        });
      }
      else {
        setState(() {
          internet=false;
        });
        // print("Connection: not present");
        //  print(internet);
      }
      // No-Internet Case
    });
  }
}
