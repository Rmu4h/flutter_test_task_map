import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_test_task_map/pages/profile-page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:location/location.dart';
// import 'package:path_provider/path_provider.dart' as pathProvider;
// import 'package:path/path.dart' as path;
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'dart:ui' as ui;
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../logic/global-variables.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const _initialCameraPosition = CameraPosition(
      target: showLocation,
      zoom: 11.5
  );

  late GoogleMapController _googleMapController;
  final Completer<GoogleMapController> _controller = Completer();

  bool originExist = false;
  bool destinationExist = false;

  // final Set<Marker> markers = Set(); //markers for google map
  List<Marker> markers = []; //markers for google map

  List<Marker> myTappedDirectionMarker = [];
  static const LatLng showLocation = LatLng(
      27.7089427, 85.3086209); //location to show in map
  late Marker lastTappedEl;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  LocationData? currentLocation;

  List<LatLng> polylineCoordinates = [];
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
   LatLng destination = const LatLng(27.8089437, 85.3086219);

  String location = "Search Location";


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

                Positioned(  //search input bar
                    top:10,
                    child: InkWell(
                        onTap: () async {
                          var place = await PlacesAutocomplete.show(
                              context: context,
                              apiKey: googleApiKey,
                              mode: Mode.overlay,
                              types: [],
                              strictbounds: false,
                              components: [Component(Component.country, 'np')],
                              //google_map_webservice package
                              onError: (err){
                                print(err);
                              }
                          );

                          if(place != null){
                            setState(() {
                              location = place.description.toString();
                            });

                            //form google_maps_webservice package
                            final plist = GoogleMapsPlaces(apiKey:googleApiKey,
                              apiHeaders: await GoogleApiHeaders().getHeaders(),
                              //from google_api_headers package
                            );
                            String placeid = place.placeId ?? "0";
                            final detail = await plist.getDetailsByPlaceId(placeid);
                            final geometry = detail.result.geometry!;
                            final lat = geometry.location.lat;
                            final lang = geometry.location.lng;
                            var newlatlang = LatLng(lat, lang);


                            //move map camera to selected place with animation
                            _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                          }
                        },
                        child:Padding(
                          padding: const EdgeInsets.fromLTRB(50,40,50,15),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width - 100,

                              child: ListTile(
                                  title:Text(location, style: const TextStyle(fontSize: 18),),
                                  trailing: const Icon(Icons.search),
                                  dense: true,
                                )
                            ),
                          ),
                        )
                    )
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
              CameraUpdate.newCameraPosition(_initialCameraPosition),
            ),
        child: const Icon(Icons.center_focus_strong),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<Marker> getMarkers()  {
    //markers to place on map

    setState(() {
      markers.add(
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

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey, // Your Google Map Key
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

  _handleTap(tappedPoint) {
    destination = tappedPoint;
    lastTappedEl = Marker(
      markerId: MarkerId(destination.toString()),
      position: destination,
      // draggable: true,
      icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
      // onDragEnd: (dragEndPosition) {
      // },
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
    getPolyPoints();
    polylineCoordinates = [];
    markers = [];
  }

}


