import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class spalsh_screen extends StatefulWidget {
  const spalsh_screen({Key? key}) : super(key: key);

  @override
  State<spalsh_screen> createState() => _spalsh_screenState();
}

class _spalsh_screenState extends State<spalsh_screen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed( Duration(seconds: 5),() {
      Get.offNamed("/HomePage");
    },);
  }


  @override
  Widget build(BuildContext context) {
    // Timer(Duration(seconds: 5), () {
    //   Navigator.pushReplacementNamed(context, '/');
    // });

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/spalash-icon.png"),
              )
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
