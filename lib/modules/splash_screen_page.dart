import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_app/modules/home_page.dart';
import 'login_page.dart';

class SplashScreenPage extends StatelessWidget {
  final String email;
  String? id;
  SplashScreenPage({Key? key, required this.email, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new SplashScreen(
      seconds: 6,
      navigateAfterSeconds: email == ""
          ? LoginPage()
          : HomePage(
              dataEmail: email,
              id_user: id != null ? id! : "0",
            ),
      title: Text(email),
      photoSize: 150.0,
    );
  }
}
