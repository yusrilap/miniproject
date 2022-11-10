import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/modules/signup_page.dart';
import 'package:flutter_app/network_utils/api.dart';
import 'package:flutter_app/shared/shared.dart';

import 'splash_screen_page.dart';
import 'dart:convert';

class UpdatePage extends StatefulWidget {
  final String dataEdit;
  const UpdatePage({Key? key, required this.dataEdit}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late Map<String, dynamic> dataNew;
  String email = "", password = "", role = "", name = "", image = "";
  int id = 0;
  final _controllerEmail = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerRole = TextEditingController();
  final _controllerImage = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataNew = json.decode(widget.dataEdit);
    id = dataNew['id'] ?? 0;
    email = dataNew['email'] ?? "";
    name = dataNew['name'] ?? "";
    role = dataNew['role'] ?? "";
    image = dataNew['image'] ?? "";

    _controllerEmail.text = dataNew['email'] ?? "";
    _controllerName.text = dataNew['name'] ?? "";
    _controllerRole.text = dataNew['role'] ?? "";
    _controllerImage.text = dataNew['image'] ?? "";
  }

  void update() async {
    var data = {
      'email': email,
      'password': password,
      'role': role,
      'name': name
    };
    var res = await Network().authData(data, '/update/' + id.toString());
    var body = json.decode(res.body);
    print(body);
    if (body['status'] == 1) {
      // Navigator.of(context).pushNamed('/home');
      final sp = await SharedPreferences.getInstance();
      String? emailUser = sp.getString('email');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SplashScreenPage(email: emailUser!)));
    } else {
      var pesanError = "";
      if (body['reason'] != null) {
        pesanError = body['reason'];
      } else {
        pesanError = "Gagal UPDATE";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(pesanError)));
    }
  }

  bool _isObscure = true;
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "UDPATE DATA,",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  TextField(
                    controller: _controllerEmail,
                    onChanged: (value) => email = value,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        suffixIcon: InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.email_outlined,
                            color: Colors.red,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _controllerName,
                    onChanged: (value) => name = value,
                    decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        suffixIcon: InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.red,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    onChanged: (value) => password = value,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _controllerRole,
                    onChanged: (value) => role = value,
                    decoration: InputDecoration(
                        labelText: "Role",
                        labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w600),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        suffixIcon: InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.red,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => update(),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xffff5f6d),
                              Color(0xffff5f6d),
                              Color(0xffffc371),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                              minHeight: 50, maxWidth: double.infinity),
                          child: Text(
                            "Update",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
