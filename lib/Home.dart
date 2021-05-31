import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './Button.dart';
import './demo.dart';
import './waterTank.dart';
import 'about.dart';
import 'main.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart'
    show Connectivity, ConnectivityResult;


class Home extends StatefulWidget {
  String email,ipAddress;
  bool check_url;
   Home(this.email,this.ipAddress,this.check_url);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>  with AutomaticKeepAliveClientMixin{


  // checking the internet connectivity
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
  List name=[];
  List pg=[];
  List data;
  String total_devices;
  List data_values;
  String local_ip;
  Future get_name() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      local_ip=prefs.get('ip');
      print("Local Ip address ${local_ip}");
      print("check url ${widget.check_url}");

    });
    if(widget.check_url==false){
      final response = await http.get(Uri.http("34.83.46.202", "/cyberhome/home.php",{"username":"${widget.email}","query":"table"}));
      var fetchdata = jsonDecode(response.body);
      if(response.statusCode ==200){
        setState(() {
          data = fetchdata;
        });

        for(int i=0;i<data.length;i++){
          if(data[i].toString().contains("_Admin_Room") && (!name.contains(data[i].toString().contains("Admin_Room")))){
            name.add("Admin_Room");
            pg.add( "Admin_Room" );
          }
          else if(data[i].toString().contains("_Hall") && (!name.contains(data[i].toString().contains("Hall")))){
            name.add("Hall");
            pg.add("Hall");
          }
          else if(data[i].toString().contains("Living_Room") && (!name.contains(data[i].toString().contains("Living_Room")))){
            name.add("Living_Room");
            pg.add("Living_Room");
          }
          else if(data[i].toString().contains("_Garage") && (!name.contains(data[i].toString().contains("Garage")))){
            name.add("Garage");
            pg.add("Garage");
          }
          else if(data[i].toString().contains("_Kitchen") && (!name.contains(data[i].toString().contains("Kitchen")))){
            name.add("Kitchen");
            pg.add("Kitchen");
          }
          else if(data[i].toString().contains("_Bathroom") && (!name.contains(data[i].toString().contains("Bathroom")))){
            name.add("Bathroom");
            pg.add("Bathroom");
          }
          else if(data[i].toString().contains("Master_Bedroom") && (!name.contains(data[i].toString().contains("Master_Bedroom")))){
            name.add("Master_Bedroom");
            pg.add("Master_Bedroom");
          }
          else if(data[i].toString().contains("_Bedroom") && (!name.contains(data[i].toString().contains("Bedroom")))){
            name.add("Bedroom");
            pg.add("Bedroom");
          }
          else if(data[i].toString().contains("_Bedroom1") && (!name.contains(data[i].toString().contains("Bedroom_1")))){
            name.add("Bedroom_1");
            pg.add("Bedroom_1");
          }
          else if(data[i].toString().contains("_Bedroom2") && (!name.contains(data[i].toString().contains("Bedroom_2")))){
            name.add("Bedroom_2");
            pg.add("Bedroom_2");
          }
          else if(data[i].toString().contains("_Store_Room") && (!name.contains(data[i].toString().contains("Store_Room")))){
            name.add("Store_Room");
            pg.add("Store_Room");
          }
          else if(data[i].toString().contains("_Outside") && (!name.contains(data[i].toString().contains("Outside")))){
            name.add("Outside");
            pg.add("Outside");
          }
          else if(data[i].toString().contains("_Parking") && (!name.contains(data[i].toString().contains("Parking")))){
            name.add("Parking");
            pg.add("Parking");
          }
          else if(data[i].toString().contains("_Outside") && (!name.contains(data[i].toString().contains("Outside")))){
            name.add("Outside");
            pg.add("Outside");
          }
          else if(data[i].toString().contains("_Garden") && (!name.contains(data[i].toString().contains("Garden")))){
            name.add("Garden");
            pg.add("Garden");
          }
        }
      }
      setState(() {
        name=name.toSet().toList();
        pg=pg.toSet().toList();
        print(name);

      });
      return "success";
    }
    else{
      final response = await http.get(Uri.http("$local_ip","/key"));
      var fetchdata = jsonDecode(response.body);
      if(response.statusCode ==200){
        setState(() {
          data = fetchdata;
        });
        for(int i=0;i<data.length;i++){
          if(data[i].toString().contains("_Admin_Room") && (!name.contains(data[i].toString().contains("Admin_Room")))){
            name.add("Admin_Room");
            pg.add( "Admin_Room" );
          }
          else if(data[i].toString().contains("_Hall") && (!name.contains(data[i].toString().contains("Hall")))){
            name.add("Hall");
            pg.add("Hall");
          }
          else if(data[i].toString().contains("Living_Room") && (!name.contains(data[i].toString().contains("Living_Room")))){
            name.add("Living_Room");
            pg.add("Living_Room");
          }
          else if(data[i].toString().contains("_Garage") && (!name.contains(data[i].toString().contains("Garage")))){
            name.add("Garage");
            pg.add("Garage");
          }
          else if(data[i].toString().contains("_Kitchen") && (!name.contains(data[i].toString().contains("Kitchen")))){
            name.add("Kitchen");
            pg.add("Kitchen");
          }
          else if(data[i].toString().contains("_Bathroom") && (!name.contains(data[i].toString().contains("Bathroom")))){
            name.add("Bathroom");
            pg.add("Bathroom");
          }
          else if(data[i].toString().contains("Master_Bedroom") && (!name.contains(data[i].toString().contains("Master_Bedroom")))){
            name.add("Master_Bedroom");
            pg.add("Master_Bedroom");
          }
          else if(data[i].toString().contains("_Bedroom") && (!name.contains(data[i].toString().contains("Bedroom")))){
            name.add("Bedroom");
            pg.add("Bedroom");
          }
          else if(data[i].toString().contains("_Bedroom1") && (!name.contains(data[i].toString().contains("Bedroom_1")))){
            name.add("Bedroom_1");
            pg.add("Bedroom_1");
          }
          else if(data[i].toString().contains("_Bedroom2") && (!name.contains(data[i].toString().contains("Bedroom_2")))){
            name.add("Bedroom_2");
            pg.add("Bedroom_2");
          }
          else if(data[i].toString().contains("_Store_Room") && (!name.contains(data[i].toString().contains("Store_Room")))){
            name.add("Store_Room");
            pg.add("Store_Room");
          }
          else if(data[i].toString().contains("_Outside") && (!name.contains(data[i].toString().contains("Outside")))){
            name.add("Outside");
            pg.add("Outside");
          }
          else if(data[i].toString().contains("_Parking") && (!name.contains(data[i].toString().contains("Parking")))){
            name.add("Parking");
            pg.add("Parking");
          }
          else if(data[i].toString().contains("_Outside") && (!name.contains(data[i].toString().contains("Outside")))){
            name.add("Outside");
            pg.add("Outside");
          }
          else if(data[i].toString().contains("_Garden") && (!name.contains(data[i].toString().contains("Garden")))){
            name.add("Garden");
            pg.add("Garden");
          }
        }
      }
      setState(() {
        name=name.toSet().toList();
        pg=pg.toSet().toList();
        print(name);

      });
      return "success";
    }

  }
  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', "");
    await prefs.setString('password', "");
    await prefs.setString('ip', "");
    await prefs.setBool('isLoggedIn',false);
    await prefs.setBool('check_url', false);
    await prefs.setBool('login', true);
    return true;
  }

  // don't change the online url
  Future get_Ip() async{
    final response = await http.get(Uri.http("34.83.46.202", "/cyberhome/home.php",{"username":"${widget.email}","query":"table"}));
    final response_value = await http.get(Uri.http("34.83.46.202", "/cyberhome/home.php",{"username":"${widget.email}","query":"value"}));
    var fetchdata = jsonDecode(response.body);
    var fetc_values = jsonDecode(response_value.body);
    List ip_data;
    List ip_data_value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('login', false);
    if(response.statusCode==200) {
      setState( () {
        ip_data = fetchdata;
        ip_data_value = fetc_values;
      } );
      for(int i=0;i<ip_data.length;i++) {
        print( "ip offline ${ip_data[i].toString( )}" );
        if(ip_data[i].toString().contains("local")){
          setState(() async{
            ln=ip_data[i].toString();
            ipValue=ip_data_value[0][i].toString();
            ipIndex=i;
            await prefs.setString('ip', ipValue);
            print("ip address $ipValue");
            checkIP();
          });
        }
      }

    }

  }

  String ln,ipValue;
  int ipIndex;
  String ipAddress;

  Future<bool> checkIP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ipad = await prefs.get('ip');
    ipAddress = ipad;
    print(ipad);
    return true;
  }
  Future<bool> islogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance( );
    await prefs.setBool('isLoggedIn',true);
  }
  bool isSwitched;
  Future geturl() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool check_url= await prefs.get('check_url');
    setState(() {
      isSwitched=check_url;
    });
    print("check the statu${check_url} ");
  }

  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_Ip();
    get_name();
    islogged();

    geturl();
   timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
     get_name();
     });
    print("url type: ${widget.check_url}");
   }
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
     final height =MediaQuery.of(context).size.height;
     final width = MediaQuery.of(context).size.width;
     SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
       DeviceOrientation.portraitDown,
     ]);
     return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.white,
        drawer: Container(
          width: MediaQuery.of(context).size.width*0.6,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: height*0.1,
                              width: width*0.4,
                              child: Image.asset("assets/onwords1.png")),
                          Text("Welcome",style: GoogleFonts.robotoSlab(color: Colors.grey[700]),),
                          Text("${widget.email}",style: GoogleFonts.robotoSlab(fontSize: 20,color: Colors.grey[700]),),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>waterTank(widget.email,local_ip)));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.opacity,color: Colors.grey[700]),
                        SizedBox(width: 20,),
                        Text("Water tank ",style: GoogleFonts.robotoSlab(color: Colors.grey[700]))
                      ],
                    ),
                  ),
                ),
               /* InkWell(
                  onTap: (){
                    setState(() {
                      updateMood();
                    });
                  },
                  child: Row(
                    children: [
                      IconButton(icon: _icon,color: Colors.grey[700], onPressed: (){}),
                      Text("Day/Light mode",style: GoogleFonts.robotoSlab(color: Colors.grey[700])),
                      SizedBox(width: 20,),

                    ],
                  ),
                ),*/
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Demo()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.settings_remote,color: Colors.grey[700] ),
                        SizedBox(width: 20,),
                        Text("Universal remote",style: GoogleFonts.robotoSlab(color: Colors.grey[700]))
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Demo()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.camera,color: Colors.grey[700]),
                        SizedBox(width: 20,),
                        Text("Cctv",style: GoogleFonts.robotoSlab(color: Colors.grey[700]))
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Demo()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.security,color: Colors.grey[700]),
                        SizedBox(width: 20,),
                        Text("Security System",style: GoogleFonts.robotoSlab(color: Colors.grey[700]))
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Demo()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.broken_image,color: Colors.grey[700]),
                        SizedBox(width: 20,),
                        Text("Curtain Controls",style: GoogleFonts.robotoSlab(color: Colors.grey[700]))
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings(widget.check_url,isSwitched)));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.settings,color: Colors.grey[700]),
                        SizedBox(width: 20,),
                        Text("Settings",style: GoogleFonts.robotoSlab(color: Colors.grey[700]))
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>About(widget.email,local_ip,widget.check_url)));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,color: Colors.grey[700]),
                        SizedBox(width: 20,),
                        Text("About home",style: GoogleFonts.robotoSlab(color: Colors.grey[700]))
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    logout().then((value) =>
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyApp()),
                              (Route<dynamic> route) => false,
                        ));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app,color: Colors.grey[700]),
                        SizedBox(width: 20,),
                        Text("Log out",style: GoogleFonts.robotoSlab(color: Colors.grey[700]))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          key: UniqueKey(),
          children: [
            Container(
              child:Container(
                margin: EdgeInsets.only(bottom: height*0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                       //margin: EdgeInsets.only(bottom: height*0.07),
                      child: IconButton(icon: Icon(Icons.menu,color: Colors.white,size: height*0.04,),
                        onPressed: (){
                          _scaffoldKey.currentState.openDrawer();
                        },),

                    ),
                    Container(/*margin:EdgeInsets.only(bottom: height*0.08,left: width*0.2),*/child: Center(child: Text("Smart Home".toString().replaceAll("_", " "),style: GoogleFonts.robotoSlab(fontSize: 20,color: Colors.white),))),
                    Container(
                      padding:  const EdgeInsets.all(15.0),
                    ),
                  ],
                ),
              ),
              height: height*0.2,
              width: width*1,
              decoration:BoxDecoration(
               color: Colors.grey[800]
              )
            ),
                Container(
                  margin: EdgeInsets.only(top:height*0.13),
                  width: width*12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.elliptical(20, 20),topRight:Radius.elliptical(20,20) ),
                      color:Colors.grey[900]
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                  scrollDirection: Axis.vertical,
                                  itemCount: name.length,
                                  itemBuilder: (context,index){
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Button(widget.email,name[index].toString(),index,local_ip,widget.check_url)));
                                        },
                                        child: Container(
                                            // style: NeumorphicStyle(
                                            //     shape: NeumorphicShape.concave,
                                            //     boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                                            //     depth: 0.1,
                                            //     intensity: 1,
                                            //     //lightSource: LightSource.bottomLeft,
                                            //     color:  _color1,
                                            // ),
                                            //curveType: CurveType.concave,
                                           // bevel: 10,
                                            decoration:BoxDecoration(
                                              color: Colors.grey[900],
                                              borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(-1,-1),
                                                      color: Colors.grey[700],
                                                      blurRadius: 1,
                                                      spreadRadius: 1
                                                  ),
                                                  BoxShadow(
                                                      offset: Offset(1,1),
                                                      color: Colors.grey[700],
                                                      blurRadius: 1,
                                                      spreadRadius: 1
                                                  )
                                                ]
                                            ),
                                            height: height*0.2,
                                            width: width*0.2,
                                            margin: EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(15),
                                                  child: name[index].toString().contains("Hall")?Image.asset("assets/livingroom.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Admin")?Image.asset("assets/adminroom.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Garage")?Image.asset("assets/garage.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Kitchen")?Image.asset("assets/kitchen.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Bathroom")?Image.asset("assets/bathroom.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Bedroom_1")?Image.asset("assets/bedroom1.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Bedroom_2")?Image.asset("assets/bedroom2.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Master_Bedroom")?Image.asset("assets/masterbedroom.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Bedroom")?Image.asset("assets/bedroom.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Outside")?Image.asset("assets/outside.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Garden")?Image.asset("assets/garden.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Parking")?Image.asset("assets/parking.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Living_Room")?Image.asset("assets/livingroom2.png",width: width*0.2,height: height*0.1,)
                                                      :name[index].toString().contains("Store_Room")?Image.asset("assets/storeroom.png",width: width*0.2,height: height*0.1,):Container(),
                                                ),
                                                  SizedBox(
                                                    height: height*0.01,
                                                  ),
                                                  Text("${name[index].toString().replaceAll("_"," ")}",style: GoogleFonts.robotoSlab(fontSize: 13,color: Colors.white),),
                                              ],
                                            )
                                        ),
                                      ),
                                    );
                                  }),
                      ),
                    ],
                  ),
                ),

              ],
            ),
        ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}