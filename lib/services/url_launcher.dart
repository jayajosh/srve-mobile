import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

void reportBug() async {
  final _uri = "mailto:a012519j@student.staffs.ac.uk?subject=Bug%20Report&body=Platform:%20${Platform.operatingSystem}";

if (await canLaunch(_uri)) {
    await launch(_uri);
  } else {
    print('Could not launch $_uri'); //Todo make this a popup
  }
}