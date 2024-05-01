import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

String dateToString(DateTime? date) {
  if (date == null) return "Pas de date limite";
  return "${date.day}/${date.month}/${date.year}";
}

Future<LatLng?> checkAddress(String? addr) async {
  try {
    // Géocodage de l'adresse
    final List<Location> locations = await locationFromAddress(addr!);
    // Vérification si des emplacements ont été trouvés
    if (locations.isNotEmpty){
      final Location location = locations.first;
      return LatLng(location.latitude, location.longitude);
    }
    return null;
  } catch (e) {
    return null;
  }
}
