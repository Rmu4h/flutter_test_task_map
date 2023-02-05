import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

String userName = '';
String profilePicture = '';
String profileEmail = '';
var myCustomAvatarIcon = BitmapDescriptor.defaultMarkerWithHue(markerColor);

final GoogleSignIn googleSignIn = GoogleSignIn();
const String google_api_key = 'AIzaSyBvAr4Vog5K9vXIApXVjWAiXLJ8I1dclNI';
var markerColor = BitmapDescriptor.hueYellow;



