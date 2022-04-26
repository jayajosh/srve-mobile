import 'package:flutter/material.dart';

class Navigation{
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static Navigation instance = Navigation();

}