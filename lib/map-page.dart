import 'dart:async';
// import 'dart:html';
import 'dart:io';

import 'package:custom_marker/marker_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_test_task_map/profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:ui' as ui;

import 'global-variables.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // final Completer<GoogleMapController> _controller = Completer();
  //
  // static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  // static const LatLng destination = LatLng(37.33429383, -122.06600055);

  static const _initialCameraPosition = CameraPosition(
      target: showLocation,
      zoom: 11.5
  );

  late GoogleMapController _googleMapController;
  final Completer<GoogleMapController> _controller = Completer();

  bool originExist = false;
  bool destinationExist = false;

  late Marker _origin;
  late Marker _destination;

  // final Set<Marker> markers = Set(); //markers for google map
  List<Marker> markers = []; //markers for google map

  List<Marker> myTappedDirectionMarker = [];
  static const LatLng showLocation = LatLng(
      27.7089427, 85.3086209); //location to show in map
  late Marker lastTappedEl;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  final String _url = profilePicture;
  File? _displayImage;
  LocationData? currentLocation;

  List<LatLng> polylineCoordinates = [];
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
   LatLng destination = const LatLng(27.8089437, 85.3086219);

  @override
  void initState() {
    // setCustomMarkerIcon();
    // _download();
    // getCurrentLocation();
    getPolyPoints();

    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, // Your Google Map Key
      PointLatLng(showLocation.latitude, showLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty ) {
      result.points.forEach(
            (PointLatLng point) {
              return polylineCoordinates.add(
                LatLng(point.latitude, point.longitude),
              );
            }
      );
      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      body: Center(
        child: Center(
            child: Stack(
              children: [
                GoogleMap(
                    zoomGesturesEnabled: true,
                    initialCameraPosition: _initialCameraPosition,
                    // onMapCreated: (controller) => _googleMapController = controller,
                    // markers: {
                    //   originExist ? _origin : Marker(markerId: const MarkerId('origin'),),
                    //   destinationExist ? _destination : Marker(markerId: const MarkerId('destination'),),
                    //
                    //   // if (_destination != null) _destination,
                    // },
                    markers: getmarkers().toSet(),
                    // onLongPress: _addMarker,
                    mapType: MapType.normal,
                    //map type
                    onMapCreated: (
                        controller) { //method called when map is created
                      setState(() {
                        _googleMapController = controller;
                        _controller.complete(controller);
                      });
                    },
                    onTap: _handleTap,
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: polylineCoordinates,
                        color: const Color(0xFF7B61FF),
                        width: 6,
                      ),
                    }
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                          icon: Image.asset('assets/images/icon-menu3.png'),
                          iconSize: 30,
                          onPressed: () {
                            return _scaffoldKey.currentState?.openEndDrawer();
                          },
                        ),
                ),
              ],
            )

        ),
      ),
      endDrawer: Drawer(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.9,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
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
                    .pushNamedAndRemoveUntil(context, '/', ((route) => false));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        foregroundColor: Colors.black,
        onPressed: () =>
            _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition),
            ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  List<Marker> getmarkers()  {
    //markers to place on map

    setState(() {
      markers.add(
      //     Marker(
      //   //add first marker
      //   draggable: true,
      //   onDragEnd: (dragEndPosition) {
      //     print(dragEndPosition);
      //   },
      //   markerId: MarkerId(showLocation.toString()),
      //   position: showLocation,
      //   //position of marker
      //   infoWindow: InfoWindow( //popup info
      //     title: userName,
      //     snippet: 'My location',
      //   ),
      //   // icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      //   icon: BitmapDescriptor.fromBytes(bytes) ,
      //     // icon:
      // )

        Marker(
            draggable: true,
            onDragEnd: (dragEndPosition) {
              print(dragEndPosition);
            },
            icon: myCustomAvatarIcon,
            markerId:  MarkerId(showLocation.toString()),
          position: showLocation,
        infoWindow: InfoWindow( //popup info
          title: userName,
          snippet: profileEmail,
        ),
      ),
      );

      markers.add(Marker( //add second marker
        draggable: true,

        markerId: MarkerId(destination.toString()),
        position: destination,
        //position of marker
        infoWindow: const InfoWindow( //popup info
          title: 'My direction',
          snippet: 'My Custom Subtitle',
        ),
        // icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),

      ));

      //add more markers here

      // add myTappedDirectionMarker
      print('myTappedDirectionMarker.length ${myTappedDirectionMarker.length}');

      for (var element in myTappedDirectionMarker) {
        markers.add(element);
        print('elment count ${element}');
      }
    });

    return markers;
  }

  _handleTap(tappedPoint) {
    destination = tappedPoint;
    print(tappedPoint);
    lastTappedEl = Marker(
      markerId: MarkerId(destination.toString()),
      position: destination,
      draggable: true,
      icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
      onDragEnd: (dragEndPosition) {
        print(dragEndPosition);
      },
    );

    setState(() {
      //remove last tapped marker
      myTappedDirectionMarker = [];
      // print(markers);
      // markers.remove(lastTappedEl);
      // markers.removeLast();

      // print('AFTER REMOVE ${markers}');


      // myTappedDirectionMarker.add(
      //     Marker(
      //       markerId: MarkerId(destination.toString()),
      //       position: destination,
      //       // draggable: true,
      //       icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
      //       onDragEnd: (dragEndPosition) {
      //         print(dragEndPosition);
      //       },
      //     )
      // );
    });
    // myTappedDirectionMarker = [];
    // markers.removeLast();
    getPolyPoints();
    polylineCoordinates = [];
    markers = [];
    print('this is length Markers on click - ${markers.length}');
    // setState(() {});
  }

  // void getCurrentLocation() async {
  //   Location location = Location();
  //   location.getLocation().then(
  //         (location) {
  //       currentLocation = location;
  //     },
  //   );
  //   GoogleMapController googleMapController = await _controller.future;
  //   location.onLocationChanged.listen(
  //         (newLoc) {
  //       currentLocation = newLoc;
  //       googleMapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             zoom: 13.5,
  //             target: LatLng(
  //               newLoc.latitude!,
  //               newLoc.longitude!,
  //             ),
  //           ),
  //         ),
  //       );
  //       setState(() {});
  //     },
  //   );
  // }

  // Future setCustomMarkerIcon() async {
  //   String imgurl = profilePicture;
  //   // final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //   // final Canvas canvas = Canvas(pictureRecorder);
  //   // int size = 150;
  //
  //   bytes = (await NetworkAssetBundle(Uri.parse(imgurl))
  //       .load(imgurl))
  //       .buffer
  //       .asUint8List();
  //   print(bytes);
  //
  //   // final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  //   // final ui.FrameInfo imageFI = await codec.getNextFrame();
  //   // paintImage(
  //   //     canvas: canvas,
  //   //     rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
  //   //     image: imageFI.image);
  //   //
  //   //
  //   // final _image =
  //   // await pictureRecorder.endRecording().toImage(size, (size * 1.1).toInt());
  //   // final data = await _image.toByteData(format: ui.ImageByteFormat.png);
  //   //
  //   // //convert PNG bytes as BitmapDescriptor
  //   // if(data?.buffer.asUint8List() != null) {
  //   //   var result = BitmapDescriptor.fromBytes(data?.buffer.asUint8List() ?? bytes);
  //   // }
  //     // return BitmapDescriptor.fromBytes(data?.buffer.asUint8List() ?? bytes);
  //
  //   // BitmapDescriptor.fromAssetImage(
  //   //     ImageConfiguration.empty, _displayImage?.readAsStringSync() ?? '')
  //   //     .then(
  //   //       (icon) {
  //   //     sourceIcon = icon;
  //   //   },
  //   // );
  // }



}


