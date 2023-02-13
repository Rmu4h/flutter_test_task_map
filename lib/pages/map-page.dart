import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_test_task_map/pages/profile-page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';

import '../logic/global-variables.dart';
import 'elements/search-input.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CameraPosition? _initialCameraPosition;

  late GoogleMapController _googleMapController;
  final Completer<GoogleMapController> _controller = Completer();

  List<Marker> markers = []; //markers for google map

  List<Marker> myTappedDirectionMarker = [];
  LatLng? showLocation; //location to show in map
  late Marker lastTappedEl;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  LocationData? currentLocation;

  List<LatLng> polylineCoordinates = [];
  LatLng destination = const LatLng(27.8089437, 85.3086219);

  String location = "Search Location";


  @override
  void initState() {
    super.initState();

    getCurrentLocation();
    getPolyPoints();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
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
                    initialCameraPosition: _initialCameraPosition ?? CameraPosition(
                        target: showLocation ?? const LatLng(
                            27.7089427, 85.3086209),
                        zoom: 9.5
                    ),
                    markers: getMarkers().toSet(),
                    mapType: MapType.normal,
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


                const Positioned(
                    top: 10,
                    child: SearchInput()
                ),
                Positioned(
                  top: 20,
                  right: 10,
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
              CameraUpdate.newCameraPosition(_initialCameraPosition ?? CameraPosition(
                  target: showLocation ?? const LatLng(
                      27.7089427, 85.3086209),
                  zoom: 9.5
              )),
            ),
        child: const Icon(Icons.center_focus_strong),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  //function that adds markers to the map
  List<Marker> getMarkers()  {
    //markers to place on map

    setState(() {
      markers.add(
        Marker(
          draggable: true,
          onDragEnd: (dragEndPosition) {},
          icon: myCustomAvatarIcon,
          markerId:  MarkerId(showLocation.toString()),
          position: showLocation ?? const LatLng(
              27.7089427, 85.3086209),
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
        icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
      ));

      //add more markers here

      // add myTappedDirectionMarker

      for (var element in myTappedDirectionMarker) {
        markers.add(element);
      }
    });

    return markers;
  }

  //function that adds routes
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey, // Your Google Map Key
      PointLatLng(showLocation?.latitude ?? 27.7089427, showLocation?.longitude ?? 85.3086209),
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

  //changes the destination to a point per click
  _handleTap(tappedPoint) {
    destination = tappedPoint;
    lastTappedEl = Marker(
      markerId: MarkerId(destination.toString()),
      position: destination,
      icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
    );

    setState(() {
      myTappedDirectionMarker = [];
    });
    getPolyPoints();
    polylineCoordinates = [];
    markers = [];
  }

  //gets the current location and changes the location of the camera
  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then(
          (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
          (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 9.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );

        showLocation = LatLng(
            currentLocation!.latitude!, currentLocation!.longitude!);

        _initialCameraPosition = CameraPosition(
            target: showLocation ?? const LatLng(
                27.7089427, 85.3086209),
            zoom: 9.5
        );
        setState(() {});
      },
    );
  }
}