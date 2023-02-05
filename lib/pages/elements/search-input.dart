import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../../logic/global-variables.dart';
import 'package:google_api_headers/google_api_headers.dart';



class SearchInput extends StatefulWidget {
  const SearchInput({Key? key}) : super(key: key);

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  String location = "Search Location";
  late GoogleMapController _googleMapController;


  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                // print(err);
              }
          );

          if(place != null){
            setState(() {
              location = place.description.toString();
            });

            //form google_maps_webservice package
            final plist = GoogleMapsPlaces(apiKey:googleApiKey,
              apiHeaders: await const GoogleApiHeaders().getHeaders(),
              //from google_api_headers package
            );
            String placeid = place.placeId ?? "0";
            final detail = await plist.getDetailsByPlaceId(placeid);
            final geometry = detail.result.geometry!;
            final lat = geometry.location.lat;
            final lang = geometry.location.lng;
            var newLatLang = LatLng(lat, lang);


            //move map camera to selected place with animation
            _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newLatLang, zoom: 17)));
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
    );
  }
}
