import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


final username = TextEditingController();
final email = TextEditingController();
final name = TextEditingController();
final password = TextEditingController();
final _formKey = GlobalKey<FormState>();



final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class Signup extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _counter;
  bool eye = true;

  void _toggle() {
    setState(() {
      eye = !eye;
    });
  }


  bool isEnabled = true ;
  enableButton(){

    setState(() {
      isEnabled = true;
    });
  }

  disableButton(){

    setState(() {
      isEnabled = false;
    });
  }

  void _incrementCounter(String a) {
    setState(() {

      _counter=a;
    });
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
  String validateUsername(String value) {
    Pattern pattern = r'[-/\s/@_!#$%^&*()<>?/\|}{~:]';
    RegExp regex = new RegExp(pattern);
    if (value.length < 3){
      return 'Username must be more than 3 characters';
    }
    else if (regex.hasMatch(value)) {
      return 'Username can only contain Alphabets and Numbers';
    }
    else
      return null;
  }


  List data;
  Future getData() async {
    disableButton();
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {

      _counter=null;
    });
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration:Duration(seconds:988), content:
        new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Signing-In...")
          ],
        ),
        ));
    var response = await http.post(
      'https://378b9fd8c340.ngrok.io/onboarding/signup/',
      body:{
        'name': name.text,
        'username': username.text,
        'email': email.text,
        'password': password.text,
      },
    );
    print(response);
    _scaffoldKey.currentState.hideCurrentSnackBar();
    enableButton();
    if (response.statusCode == 201) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      data = json.decode(response.body);
      print(data[0]['key']);
      prefs.setString('key', data[0]['key']);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondRoute()),
      );
    }
    else if (response.statusCode == 406) {
      _incrementCounter("Username Already Taken");

    }
    else {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content:
          new Row(
            children: <Widget>[
              new   Icon(
                Icons.error,
                color: Colors.red,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),

              new Text(" Something went wrong, Please try again")
            ],
          ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          new AbsorbPointer(
            absorbing: !isEnabled,
            child:Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 20, 0),
              child: new FlatButton(
                child: new Text("Log In",
                  style: new TextStyle(color: Colors.grey, fontSize: 17),),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },
                highlightColor: Colors.black,
                shape: StadiumBorder(),
              ),
            ),
          ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: !isEnabled,
        child: SingleChildScrollView(


          child: new Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Form(
              key: _formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Text(
                    "Sign up",
                    style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                  new SizedBox(
                    height: 60,
                  ),
                  new TextFormField(
                    onChanged: (text) {
                      setState(() {

                        _counter=null;
                      });
                    },
                    controller: username,
                    validator: validateUsername,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: new InputDecoration(
                      // hintText: "Email",
                      labelText: "Create Username",
                    ),
                  ),
                  if( _counter != null)
                    Text(
                        '$_counter',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)
                    ),

                  new SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    controller: email,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: new InputDecoration(
                      // hintText: "Email",
                      labelText: "Email",
                    ),
                  ),
                  new SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    controller: name,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    decoration: new InputDecoration(
                      // hintText: "Email",
                      labelText: "Name",
                    ),
                  ),
                  new SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    controller: password,
                    validator: (value) {
                      if (value.length < 5) {
                        return 'Password must be more than 5 characters ';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    decoration: new InputDecoration(
                      labelText: "Password",
                      suffixIcon: new GestureDetector(
                        child: new Icon(
                          Icons.remove_red_eye,
                        ),
                        onTap: _toggle,
                      ),
                    ),
                    obscureText: eye,
                  ),
                  new SizedBox(
                    height: 30,
                  ),
                  new SizedBox(
                    height: 50,
                    child: new RaisedButton(
                        child: new Text("Sign up",
                            style: new TextStyle(color: Colors.white)),
                        color: Colors.black,
                        elevation: 15.0,
                        shape: StadiumBorder(),
                        splashColor: Colors.white54,
                        onPressed: () {
                          if (_formKey.currentState.validate())
                          {
                            if(isEnabled)
                            {
                              getData();
                            }
                            else
                            {
                              null;
                            }
                          }
                        }
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: new Text(
                      "Or sign up with social account",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(

                        child: new OutlineButton(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(
                                FontAwesomeIcons.facebookF,
                                size: 20,
                              ),
                              new SizedBox(
                                width: 5,
                              ),
                              new Text("Facebook",
                                  style: new TextStyle(color: Colors.black)),
                            ],
                          ),
                          shape: StadiumBorder(),
                          highlightedBorderColor: Colors.black,
                          borderSide: BorderSide(color: Colors.black),
                          onPressed: () {},
                        ),
                      ),
                      new SizedBox(
                        width: 20,
                      ),
                      new Expanded(

                        child: new OutlineButton(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(
                                FontAwesomeIcons.twitter,
                                size: 20,
                              ),
                              new SizedBox(
                                width: 5,
                              ),
                              new Text("Twitter",
                                  style: new TextStyle(color: Colors.black)),
                            ],
                          ),
                          shape: StadiumBorder(),
                          highlightedBorderColor: Colors.black,
                          borderSide: BorderSide(color: Colors.black),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  new SizedBox(height: 60),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("By signing up you agree to our "),
                      new GestureDetector(
                          child: Text("Terms of Use",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              )),
                          onTap: () {})
                    ],
                  ),
                  new SizedBox(
                    height: 5,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("and "),
                      new GestureDetector(
                          child: Text("Privacy Policy",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              )),
                          onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );



  }
}
