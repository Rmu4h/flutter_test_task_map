import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'global-variables.dart';




class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

enum DefaultColor { blueColor, greenColor, orangeColor, redColor, defaultYellow}

class _AccountPageState extends State<AccountPage> {
  final List<String> entries = [
    userName,
    profileEmail,
  ];
  final List<dynamic> icons = [
    Icons.account_circle,
    Icons.email
  ];

  DefaultColor? _colorCharacter = DefaultColor.defaultYellow;


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
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        // padding: const EdgeInsets.all(8),
                        itemCount: entries.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            // height: 30,
                              padding: const EdgeInsets.fromLTRB(0,10.0,0,10.0),
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
                                          fontSize: 18
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
                      ),
                      Row(
                        children: [
                          Icon(Icons.circle, size: 30, color:
                          _colorCharacter == DefaultColor.blueColor
                              ? Colors.blue
                              : _colorCharacter == DefaultColor.greenColor
                              ? Colors.green
                              : _colorCharacter == DefaultColor.orangeColor
                              ? Colors.orange
                              : _colorCharacter == DefaultColor.redColor
                              ? Colors.red
                              : Colors.yellow
                          ),
                          TextButton(
                            onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: const Color(0xFF0F0F0F),
                                  title: const Text('Choose a marker color', style: TextStyle(color: Colors.white, fontSize: 18)),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: const Text('Blue', style: TextStyle(color: Colors.white)),
                                            leading: Radio<DefaultColor>(
                                              value: DefaultColor.blueColor,
                                              groupValue: _colorCharacter,
                                              onChanged: (DefaultColor? value) {
                                                setState(() {
                                                  _colorCharacter = value;
                                                });
                                              },
                                              fillColor: MaterialStateProperty.all<Color>(Colors.blue),
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Green', style: TextStyle(color: Colors.white)),
                                            leading: Radio<DefaultColor>(
                                              value: DefaultColor.greenColor,
                                              groupValue: _colorCharacter,
                                              onChanged: (DefaultColor? value) {
                                                // _changeFrequencyText(value);

                                                setState(() {
                                                  _colorCharacter = value;
                                                });
                                              },
                                              fillColor: MaterialStateProperty.all<Color>(Colors.green),

                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Orange', style: TextStyle(color: Colors.white)),
                                            leading: Radio<DefaultColor>(
                                              value: DefaultColor.orangeColor,
                                              groupValue: _colorCharacter,
                                              onChanged: (DefaultColor? value) {

                                                setState(() {
                                                  _colorCharacter = value;
                                                });
                                              },
                                              fillColor: MaterialStateProperty.all<Color>(Colors.orange),

                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Red', style: TextStyle(color: Colors.white)),
                                            leading: Radio<DefaultColor>(
                                              value: DefaultColor.redColor,
                                              groupValue: _colorCharacter,
                                              onChanged: (DefaultColor? value) {

                                                setState(() {
                                                  _colorCharacter = value;
                                                });
                                              },
                                              fillColor: MaterialStateProperty.all<Color>(Colors.red),

                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Change default marker color', style: TextStyle(color: Colors.white)),
                                            leading: Radio<DefaultColor>(
                                              value: DefaultColor.defaultYellow,
                                              groupValue: _colorCharacter,
                                              onChanged: (DefaultColor? value) {

                                                setState(() {
                                                  _colorCharacter = value;
                                                });
                                              },
                                              fillColor: MaterialStateProperty.all<Color>(Colors.yellow),

                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'OK');
                                        setState(() {
                                          markerColor = _colorCharacter == DefaultColor.blueColor
                                              ? BitmapDescriptor.hueBlue
                                              : _colorCharacter == DefaultColor.greenColor
                                              ? BitmapDescriptor.hueGreen
                                              : _colorCharacter == DefaultColor.orangeColor
                                              ? BitmapDescriptor.hueYellow
                                              : _colorCharacter == DefaultColor.redColor
                                              ? BitmapDescriptor.hueRed
                                              : BitmapDescriptor.hueYellow;
                                        });
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                )
                            ),
                            child: Text(
                              _colorCharacter == DefaultColor.blueColor
                                  ? 'Blue'
                                  : _colorCharacter == DefaultColor.greenColor
                                  ? 'Green '
                                  : _colorCharacter == DefaultColor.orangeColor
                                  ? 'Orange'
                                  : _colorCharacter == DefaultColor.redColor
                                  ? 'Red'
                                  : 'Default color',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
