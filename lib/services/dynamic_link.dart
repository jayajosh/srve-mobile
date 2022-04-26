import 'package:flutter/material.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../locator.dart';
import 'navigation.dart';

class DynamicLink {
  Future handleDynamicLinks() async {
    /// Get initial dynamic link ///
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLinkdata) async {
          _handleDeepLink(dynamicLinkdata);
        },
        onError: (OnLinkErrorException e) async {
          print(e);
        }
    );
  }

  void _handleDeepLink(PendingDynamicLinkData? data) {
    final Uri? deepLink = data?.link;
    if(deepLink != null) {
      var uid = deepLink.queryParameters['uid'];
      var routeName = deepLink.queryParameters['route'];
      locator<Navigation>().navigationKey.currentState!.pushNamed(
          '/Home/RouteViewer',
          arguments: [uid, routeName]);
    }
  }

  Future<String> createLink(uid,String route) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://routecreator.page.link',
      link: Uri.parse('https://www.routecreator.com/post?uid=$uid&route=$route'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.route_planner',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Route: $route',
        description: 'This link works whether app is installed or not!',
      ),/*
      // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
      iosParameters: IosParameters(
        bundleId: 'com.example.routePlanner',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Example of a Dynamic Link',
        description: 'This link works whether app is installed or not!',
      ),*/
    );

    var dynamicUrl = await parameters.buildShortLink();
    final Uri shortUrl = dynamicUrl.shortUrl;
    return shortUrl.toString();
  }

}