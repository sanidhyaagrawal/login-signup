import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class Home extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<Home> {

  List data;

  Future<String> getData() async {
  var response = await http.get(
  Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
  headers: {
  "Accept": "application/json"
  }
  );

  this.setState(() {
  data = json.decode(response.body);
  });

  print(data[1]["title"]);

  return "Success!";
  }

  @override
  void initState(){
  this.getData();
  }

  @override
  Widget build(BuildContext context){
  return new Scaffold(
  appBar: new AppBar(title: new Text("Listviews"), backgroundColor: Colors.blue),
  body: new ListView.builder(
  itemCount: data == null ? 0 : data.length,
  itemBuilder: (BuildContext context, int index){
  return new Card(
    child: InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        print('Card tapped.');
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Text(
                'Q. 1',
                style: TextStyle(
                    fontSize: 18)
            ),
            title:  Text("Part A"),//Text(data[index]["title"]),
            subtitle:  Text(
                'No Answers',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16)
            ),
          trailing:  Text("Part A"),

          ),

        ],
      ),



    ),
  );
  },
  ),
  );
  }
}