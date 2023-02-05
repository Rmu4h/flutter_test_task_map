import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/global-variables.dart';
import '../logic/processing.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {



  void signUserIn() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4095E2),
                  Color(0xFF373598),
                ],
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/tiger.png',
                    fit: BoxFit.cover,
                    width: 250,
                    height: 250,
                  ),
                  const Text(
                    'Best map ever. Login to see it',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],),
              DecoratedBox(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [
                          Colors.blueAccent,
                          Colors.redAccent,
                          Colors.purpleAccent
                          //add more colors
                        ]),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                          blurRadius: 5) //blur radius of shadow
                    ]
                ),
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                      );

                      AuthService().signInWithGoogle().then((value) {
                        if(userName.isNotEmpty){
                            Navigator.popAndPushNamed(context, '/main', arguments: value);
                        }

                      });

                      hideStatusBar();
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      disabledForegroundColor: Colors.transparent.withOpacity(0.38), disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
                      shadowColor: Colors.transparent,
                      //make color or elevated button transparent
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google-t.png',
                          fit: BoxFit.cover,
                          height: 40,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'Sign Up With Google',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future hideStatusBar() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}