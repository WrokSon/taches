import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// convertisseur de date avec un format day/month/year
String dateToString(DateTime? date) {
  if (date == null) return "Pas de date limite";
  return "${date.day}/${date.month}/${date.year}";
}

// verifier si une addresse est correcte
Future<LatLng?> checkAddress(String? addr) async {
  if (addr == null || addr.isEmpty) return null;
  try {
    GeoData data = await Geocoder2.getDataFromAddress(
      address: addr,
      googleMapApiKey: "AIzaSyAIJinBuERzfWLOUH97_-1DGelDlEhZyzg",
    );
    print('lat:${data.latitude} long:${data.longitude}');
    return LatLng(data.latitude, data.longitude);
  } catch (e) {
    return null;
  }
}

// pour les couleur en commun
Color getBackgroundColorButton() => Colors.blue;
Color getTextColor() => Colors.black;
Color? getSubtitleColor() => Colors.grey[500];
