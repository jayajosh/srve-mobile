import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:flutter_svg/flutter_svg.dart';

//import '../../services/auth.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      Navigator.pushNamedAndRemoveUntil(context, "/Home", (routes) => false);
    });
/*    if (loggedIn() == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        Navigator.pushNamedAndRemoveUntil(context, "/Home", (routes) => false);
      });
    }
    else {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        Navigator.pushNamedAndRemoveUntil(context, "/WelcomePage", (routes) => false);
      });
    }*/
    return Scaffold(
        body: Container(color: const Color(0xffFF9933),
          child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,30,0,15),
                  child: Image(image: const AssetImage("assets/Icon.png"), width: MediaQuery.of(context).size.width/3)
                ),
                const Text(
                  "SRVE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ]
          )),
        )
    );
  }
}