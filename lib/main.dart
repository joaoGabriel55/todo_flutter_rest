import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;

void main() => runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final String url = "https://todo-jsf-spring.herokuapp.com/item";

  List data;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<Null> getJsonData() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    var response = await Http.get(
        //Encode the URL
        Uri.encodeFull(url),
        //Somente aceitar JSON format
        headers: {"Accept": "application/json"});

    print(response.body);

    //String array = "[{\"id\":61,\"nome\":\"Comprar Leite e Rosas\",\"status\":false},{\"id\":62,\"nome\":\"Massa 2\",\"status\":true},{\"id\":53,\"nome\":\"Era uma vez\",\"status\":false}]";

    setState(() {
      var convertDataToJson = JSON.decode(response.body);
      print(convertDataToJson);
      data = convertDataToJson;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("TODO Flutter"),
        ),
        body: RefreshIndicator(
            key:refreshKey,
            child: new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: new Center(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Card(
                          child: new Container(
                            child: new Text(data[index]['nome']),
                            padding: const EdgeInsets.all(20.0),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            onRefresh: getJsonData)
    );
  }
}