import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:taches/models/task.dart';
import 'package:taches/tools/services.dart';

class DetailPage extends StatefulWidget {
  // route vers cette page
  static const String nameRoute = "/detail";
  final Task task; // Correction : déclarer task comme final

  // constructeur
  DetailPage({Key? key, required this.task})
      : super(key: key); // Correction : déclarer key comme Key?

  @override
  State<DetailPage> createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  double? _tempActuelle;
  double? _tempMin;
  double? _tempMax;
  String? _tempDescription;
  String _tempImg = "10d";
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // méthode pour récupérer les informations de la météo
  Future<void> _obtenirMeteo(String city) async {
    const apiKey = 'ba77f47ae48dbf46b8bde6198b02142e';
    final apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=${widget.task.position!.latitude}&lon=${widget.task.position!.longitude}&appid=$apiKey&units=metric&lang=fr";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> meteoData = json.decode(response.body);
      setState(() {
        _tempMax = meteoData['main']['temp_max'];
        _tempMin = meteoData['main']['temp_min'];
        _tempActuelle = meteoData['main']['temp'];
        _tempDescription = meteoData['weather'][0]['description'];
        _tempImg = "${meteoData["weather"][0]["icon"]}";
      });
    } else {
      throw Exception('Echec lors de la récupération des données');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.task.position != null) _obtenirMeteo("orleans");
  }

  @override
  Widget build(BuildContext context) {
    final postion = widget.task.position ?? LatLng(0.0, 0.0);
    // la section météo
    final Widget sectionMeteo = Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    "${_tempActuelle?.toInt() ?? "_"}°C",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Text(
                    "Actuelle",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "${_tempMin?.toInt() ?? "_"}°C",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text("Min"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "${_tempMax?.toInt() ?? "_"}°C",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text("Max"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: "https://openweathermap.org/img/wn/$_tempImg@2x.png",
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
              Text(_tempDescription ?? ""),
            ],
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            const Text(
              'Tache',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.task.content),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(dateToString(widget.task.dateEnd)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const Text(
                  'Adresse',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.task.address != null
                      ? widget.task.address.toString()
                      : "Pas d'adresse indiqué",
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: postion, // Coordonnées du centre de la carte
                      zoom: 15.0, // Niveau de zoom initial
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(widget.task.content),
                        position: postion,
                      ),
                    }, // Liste de marqueurs à afficher sur la carte
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: sectionMeteo,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.task.description ?? "Pas de description"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
