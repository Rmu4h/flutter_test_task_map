
import 'package:custom_marker/marker_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';

import '../global-variables.dart';
import '../map-page.dart';

class Processing {


  // Future<void> _signIn() async {
  //   await FirebaseAuth.instance.signOut();
  // }
  //
  // Future<void> _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  // }
}

class AuthService {


  signInWithGoogle() async {
    //begin iteractive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    userName = gUser!.displayName!;
    profilePicture = gUser!.photoUrl!;
    profileEmail = gUser!.email!;
    myCustomAvatarIcon = await MarkerIcon.downloadResizePictureCircle(
        profilePicture,
        size: 150,
        addBorder: true,
        borderColor: Colors.white,
        borderSize: 15);

    print(userName);
    print(profilePicture);
    print('profileEmail -- ${profileEmail}');

    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new crerdential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}