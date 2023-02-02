import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'global-variables.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      // appBar: AppBar(
      //   title: const Text('Flutter Gradient Example'),
      // ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF4095E2),
                  Color(0xFF373598),
                ],
              )
          ),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/images/icon-menu3.png'),
                      iconSize: 30,
                      onPressed: () {
                        return _scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  ],
                ),
                Text(userName),
                Text('userName'),

              ],
            )
            
          ),
        ),
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.9,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        backgroundColor: const Color(0xFF0F0F0F),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 95,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text('Settings',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
              ),
            ),
            //here just link to browse
            ListTile(
              leading: const Icon(
                    Icons.person,
                    color: Colors.white,
                ),
              title: const Text('My profile',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),

            //here just link to browse
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text('Log out',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              // tileColor:   _selected ? Color(0xFF272727) : null,

              onTap: () {
                userName = '';
                profilePicture = '';

                googleSignIn.disconnect();
                FirebaseAuth.instance.signOut();
                // Navigator.popAndPushNamed(context, "/");

                Navigator
                    .pushNamedAndRemoveUntil(context,'/', ((route) => false));
              },
            ),
          ],
        ),
      ),
    );
  }
}
