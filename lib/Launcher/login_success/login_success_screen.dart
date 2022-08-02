import 'package:flutter/material.dart';


import 'components/body.dart';

class LoginSuccessScreen extends StatefulWidget {
  static String routeName = "/login_success";

  @override
  State<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends State<LoginSuccessScreen> {

  @override
  void initState() {
    super.initState();
    //Future.delayed(Duration(seconds: 1),(() => Navigator.pushReplacementNamed(context, CartScreen.routeName)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
