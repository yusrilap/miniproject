import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/modules/signup_page.dart';
import 'package:flutter_app/modules/update_page.dart';
import 'package:flutter_app/network_utils/api.dart';
import 'package:flutter_app/shared/shared.dart';

import 'splash_screen_page.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String dataEmail;
  String? id_user;
  HomePage({Key? key, required this.dataEmail, this.id_user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = List.empty();

  Future logout() async {
    WidgetsFlutterBinding.ensureInitialized();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final sp = await _prefs;
    sp.remove('email');

    Fluttertoast.showToast(
        msg: "BERHASIL LOGOUT",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    Navigator.of(context).pushNamed('/');
  }

  void delete(id) async {
    var res = await Network().deleteData('/delete/' + id.toString());
    var body = json.decode(res.body);
    print(id);
    if (body['status'] == 1) {
      final sp = await SharedPreferences.getInstance();
      String? emailUser = sp.getString('email');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SplashScreenPage(
                email: emailUser!,
                id: id.toString(),
              )));
    } else {
      var pesanError = "";
      if (body['reason'] != null) {
        pesanError = body['reason'];
      } else {
        pesanError = "Gagal DELETE";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesanError)));
    }
  }

  Future<String> getData() async {
    var res = await Network().getData('/showAll/${widget.id_user}');
    var body = json.decode(res.body);

    if (body['status'] == 1) {
      print(body['data']);
      setState(() {
        data = body['data'];
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Gagal mengambil data")));
    }
    return "";
  }

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          foregroundColor: Color.fromRGBO(0, 103, 102, 1),
          title: Text("Home",
              style: TextStyle(color: Color.fromRGBO(0, 103, 102, 1))),
          backgroundColor: Colors.white70,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )),
            MaterialButton(
                color: Colors.red,
                child: Text("LOGOUT"),
                onPressed: () => LoginPage()),
          ],
        ),
        body: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topRight,
          //     end: Alignment.bottomLeft,
          //     colors: [
          //       Color.fromRGBO(0, 103, 102, 1),
          //       Colors.green.shade600,
          //     ],
          //   ),
          // ),
          color: Colors.grey,
          child: ListView.builder(
            itemCount: data.isEmpty ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
                  child: Container(
                    // ignore: unnecessary_new
                    decoration: new BoxDecoration(
                      boxShadow: [
                        // ignore: unnecessary_new
                        new BoxShadow(
                          color: Colors.black,
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  child: Text(
                                    data[index]["name"][0],
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  radius: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[index]["name"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      Text(data[index]["email"]),
                                      Text(data[index]["role"]),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    delete(data[index]["id"]);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  child: Text('Update'),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return UpdatePage(
                                              dataEdit:
                                                  jsonEncode(data[index]));
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          ),
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.all(10),
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text('Welcome'),
              ),
              Text(widget.dataEmail),
              MaterialButton(
                  color: Colors.red,
                  child: Text("LOGOUT"),
                  onPressed: () => LoginPage()),
            ],
          ),
        ),
      ),
    );
  }
}
