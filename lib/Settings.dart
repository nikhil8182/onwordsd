import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_restart/flutter_restart.dart';
class Settings extends StatefulWidget {
  bool check_url,isSwitched;
  Settings(this.check_url,this.isSwitched);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  Icon icondata;
  Future updateurl(bool result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('check_url',result);
    print(result==true?"On":"Off");

  }
  bool isSwitched;
  var textValue;
  Future geturl() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool check_url= await prefs.getBool('check_url');
    setState(() {
      isSwitched=check_url;
      print("switch $isSwitched");
      icondata=check_url==false?Icon(Icons.signal_cellular_4_bar,color: Colors.white,):Icon(Icons.wifi,color: Colors.white,);
      textValue=check_url==false?"Online":"Offline";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    geturl();
  }
  @override
  Widget build(BuildContext context) {
    final height =MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: (){
            Navigator.of(context).pop();
            return Future.value(true);
          },
          child: Stack(
            children: [
              Container(
                child: Container(
                  margin:EdgeInsets.only(bottom: height*0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //SizedBox(width: width*0.12,),
                      IconButton(icon: Icon(Icons.keyboard_backspace,color: Colors.white,), onPressed: (){Navigator.pop(context);}),
                      Container(child: Center(child: Text("Settings",style: GoogleFonts.robotoSlab(fontSize: 18,color: Colors.white),))),

                      Container(
                        padding:  const EdgeInsets.all(15.0),
                      ),
                    ],
                  ),
                ),
                height: height*0.15,
                width: width*1,
                decoration: BoxDecoration(
                    color: Colors.grey[800]
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top:height*0.09),
                width: width*1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.elliptical(20, 20),topRight:Radius.elliptical(20,20) ),
                    color: Colors.grey[900]
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async{
                        if(isSwitched == false)
                        {
                          setState(() {
                            icondata=Icon(Icons.signal_cellular_4_bar,color: Colors.white,);
                            isSwitched = true;
                            updateurl(true);
                            geturl();
                            textValue = 'Offline';
                            Navigator.popAndPushNamed(context,'/home');
                          });
                          print('Switch Button is ON');
                        }
                        else
                        {
                          setState(() {
                            icondata=Icon(Icons.wifi,color: Colors.white,);
                            isSwitched = false;
                            updateurl(false);
                            geturl();
                            textValue = 'Online';
                            Navigator.popAndPushNamed(context,'/home');
                          });
                          print('Switch Button is OFF');
                        }
                        setState(() {

                        });
                        final result = await FlutterRestart.restartApp();
                        print(result);

                      },
                      child: Row(
                        children: [
                          IconButton(icon: icondata, onPressed: null),
                          SizedBox(width: 10,),
                          Text("Online/offline  Current Mode : ${textValue}",style: GoogleFonts.robotoSlab(color: Colors.white)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          /*Fluttertoast.showToast(
                              msg: "Contact team Onwords!...",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey[700],
                              textColor: Colors.white,
                              fontSize: 16.0
                          );*/
                        });
                      },
                      onDoubleTap: (){

                      },
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.aspect_ratio,color: Colors.white,),
                          SizedBox(width: 25,),
                          Text("Wake on LAN",style: GoogleFonts.robotoSlab(color: Colors.white)),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    InkWell(
                      onTap: (){

                      },
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Icon(Icons.info_outline,color: Colors.white,),
                          SizedBox(width: 25,),
                          Text("About",style: GoogleFonts.robotoSlab(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
