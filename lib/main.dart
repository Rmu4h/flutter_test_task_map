// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'authorization/auth_page.dart';
import 'global-variables.dart';
import 'authorization/login.dart';
import 'map-page.dart';
import 'my-account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // String get name => 'foo';
  //
  // Future<void> initializeDefault() async {
  //   FirebaseApp app = await Firebase.initializeApp(
  //     // options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   print('Initialized default app $app');
  // }
  //
  // Future<void> initializeDefaultFromAndroidResource() async {
  //   if (defaultTargetPlatform != TargetPlatform.android || kIsWeb) {
  //     print('Not running on Android, skipping');
  //     return;
  //   }
  //   FirebaseApp app = await Firebase.initializeApp();
  //   print('Initialized default app $app from Android resource');
  // }
  //
  // Future<void> initializeSecondary() async {
  //   FirebaseApp app = await Firebase.initializeApp(
  //     // name: name,
  //     // options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //
  //   print('Initialized $app');
  // }
  //
  // void apps() {
  //   final List<FirebaseApp> apps = Firebase.apps;
  //   print('Currently initialized apps: $apps');
  // }
  //
  // void options() {
  //   final FirebaseApp app = Firebase.app();
  //   final options = app.options;
  //   print('Current options for app ${app.name}: $options');
  // }
  //
  // Future<void> delete() async {
  //   final FirebaseApp app = Firebase.app(name);
  //   await app.delete();
  //   print('App $name deleted');
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const AuthPage(), //SearchWidget MainPage
        // '/': (context) => const MapPage(), //SearchWidget MainPage

        '/main': (context) => WillPopScope(
            onWillPop: () => Future.value(false),
            child: const MapPage()),

        // '/main': (context) => const MapPage(),
      },
      // home: MapPage(),
    );
  }
}


