import 'dart:async';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../Common/color_select.dart';

Future<List<Data>> fetchData() async {
  final response =
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/albums"));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({Key? key}) : super(key: key);

  @override
  ListViewScreenState createState() => ListViewScreenState();
}

class ListViewScreenState extends State<ListViewScreen> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  void pop() {
    log("Hello");
  }

  void _deletePop(String string) {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              height: 260,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    height: 40,
                    child: const Center(
                      child: Text(
                        "Delete",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 2.0),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset(
                        'assets/images/deleteIcon.png',
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        string,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 12, right: 12, top: 8),
                        child: Text(
                            'This clinics will delete permanently.Do you still want to continue?'),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 12),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                //backgroundColor: Colors.red,
                                side: const BorderSide(
                                    color: Colors.green, width: 1),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                //backgroundColor: Colors.red,
                                padding: const EdgeInsets.only(right: 2),
                                side: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("List View"),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            // color: Colors.pink,
            image: DecorationImage(
              image: AssetImage("assets/images/backgroundImage.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder(
              future: futureData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Data> data = snapshot.data;
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                          height: 65,
                          decoration: BoxDecoration(
                              color: ColorSelect.bluegrey100,
                              borderRadius: BorderRadius.circular(12.0)),
                          //color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.all(4.0),
                                width: 240,
                                child: Column(
                                  textDirection: TextDirection.ltr,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      data[index].title,
                                    ),
                                    Text(data[index].id.toString()),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                padding: const EdgeInsets.all(2),
                                height: 35,
                                //color: Colors.pinkAccent,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        _deletePop(data[index].id.toString());
                                      },
                                      child: const Image(
                                        image: AssetImage(
                                            "assets/images/delete.png"),
                                        width: 30,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    const Image(
                                      image:
                                          AssetImage("assets/images/edit.png"),
                                      width: 30,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                } else {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                  //return Text("");
                }
              }),
        ));
  }
}

class Data {
  final int userId;
  final int id;
  final String title;

  Data({required this.userId, required this.id, required this.title});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
