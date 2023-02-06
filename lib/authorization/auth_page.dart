import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_task_map/authorization/login.dart';

import '../logic/global-variables.dart';
import '../pages/map-page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if user login
          if(snapshot.hasData && userName.isNotEmpty){
            return const MapPage();
          }

          return const Login();
        },
      ),
    );
  }
}
