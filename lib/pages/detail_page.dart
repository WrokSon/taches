import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:taches/models/task.dart';
import 'package:taches/tools/services.dart';

class DetailPage extends StatefulWidget {
  // Définition de la classe DetailPage, représentant la page de détail d'une tâche
  static const String nameRoute = "/detail"; // Route vers cette page
  final Task task; // La tâche à afficher sur cette page

  // Constructeur
  DetailPage({Key? key, required this.task}) : super(key: key);

  @override
  State<DetailPage> createState() =>
      _DetailPage(); // Création de l'état de la page
}

class _DetailPage extends State<DetailPage> {
  double? _tempActuelle; // Température actuelle
  double? _tempMin; // Température minimale
  double? _tempMax; // Température maximale
  String? _tempDescription; // Description de la météo
  String _tempImg = "10d"; // Image de la météo
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>(); // Contrôleur pour la carte Google Maps

  // Méthode pour récupérer les informations de la météo
  Future<void> _obtenirMeteo() async {
    const apiKey = 'ba77f47ae48dbf46b8bde6198b02142e'; // Clé API OpenWeatherMap
    final apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=${widget.task.position!.latitude}&lon=${widget.task.position!.longitude}&appid=$apiKey&units=metric&lang=fr"; // URL de l'API avec les coordonnées géographiques de la tâche

    // Requête HTTP pour obtenir les données météorologiques
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Si la requête est réussie
      Map<String, dynamic> meteoData = json.decode(response.body);
      setState(() {
        // Mise à jour de l'état de la page avec les données météorologiques
        _tempMax = meteoData['main']['temp_max'];
        _tempMin = meteoData['main']['temp_min'];
        _tempActuelle = meteoData['main']['temp'];
        _tempDescription = meteoData['weather'][0]['description'];
        _tempImg = "${meteoData["weather"][0]["icon"]}";
      });
    } else {
      throw Exception(
          'Echec lors de la récupération des données'); // Affichage d'une exception en cas d'échec de la requête
    }
  }

  @override
  void initState() {
    super.initState(); // Initialisation de l'état de la page
    if (widget.task.position != null)
      _obtenirMeteo(); // Récupération des données météorologiques si les coordonnées géographiques de la tâche sont disponibles
  }

  @override
  Widget build(BuildContext context) {
    final postion = widget.task.position ??
        LatLng(0.0, 0.0); // Position de la tâche sur la carte
    // Section météo
    final Widget sectionMeteo = Row(
      // Création d'une rangée pour afficher les informations météorologiques
      children: [
        Expanded(
          child: Column(
            children: [
              Column(
                children: [
                  // Température actuelle
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
                  // Température minimale
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
                  // Température maximale
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
                imageUrl:
                    "https://openweathermap.org/img/wn/$_tempImg@2x.png", // Image de la météo
                placeholder: (context, url) => const Center(
                  child:
                      CircularProgressIndicator(), // Affichage d'un indicateur de chargement en attendant le chargement de l'image
                ),
                errorWidget: (context, url, error) => const Icon(Icons
                    .error), // Affichage d'une icône d'erreur en cas d'échec de chargement de l'image
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
              Text(_tempDescription ??
                  ""), // Affichage de la description de la météo
            ],
          ),
        ),
      ],
    );
    return Scaffold(
      // Construction de l'interface utilisateur de la page de détail
      appBar: AppBar(
        title: const Text(
          "Detail",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: getBackgroundColor(),
      ),
      body: Container(
        margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            // Section de la tâche
            const Text(
              'Tache',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.task.content),
            const SizedBox(
              height: 10,
            ),
            // Section de la date
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
            // Section de l'adresse
            Column(
              children: [
                const Text(
                  'Adresse',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.task.address != null &&
                          widget.task.address!.trim().isNotEmpty
                      ? widget.task.address.toString()
                      : "Pas d'adresse indiqué",
                ),
                const SizedBox(
                  height: 5,
                ),
                // Creation de la carte
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: postion,
                      zoom: 15.0,
                    ),
                    markers: {
                      // ajout du marker
                      Marker(
                        markerId: MarkerId(widget.task.content),
                        position: postion,
                      ),
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                // Affichage de la section météo
                SizedBox(
                  width: 270,
                  child: sectionMeteo,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // Section de la description
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
