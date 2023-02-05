import 'package:flutter/material.dart';

import 'global-variables.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> entries = [
      userName,
      profileEmail,
    ];
    final List<dynamic> icons = [
      Icons.account_circle,
      Icons.email
    ];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/");
                    },
                  ),
                ],
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: SizedBox(
                    height: 150,
                    child: CircleAvatar(
                      radius: 70, // Image radius
                      backgroundImage: NetworkImage(profilePicture)),
                    ) ,
              ),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        // height: 30,
                          padding: const EdgeInsets.all(10.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(
                                icons[index],
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(' ${entries[index]}',
                                  // textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28
                                  )),
                            ],
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      thickness: 1,
                      endIndent: 0,
                      color: Colors.black,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

}
