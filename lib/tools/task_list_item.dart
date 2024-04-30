import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:taches/models/task.dart';
import 'package:taches/pages/add_edit_page.dart';
import 'package:taches/tools/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class TaskListItem extends StatefulWidget {
  final Task task;
  const TaskListItem({super.key, required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItem(task);
}

class _TaskListItem extends State<TaskListItem> {
  final Task _task;
  int? _tempActuelle;
  int? _tempMin;
  int? _tempMax;
  String? _tempDescription;
  String _tempImg = "10d";
  _TaskListItem(this._task);

  // method pour recuperer les informations de la meteo
  Future<void> _obtenirMeteo(String city) async {
    const apiKey =
        'ba77f47ae48dbf46b8bde6198b02142e'; // La clé API à demander sur OpenWeatherMap
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=fr';

    final reponse = await http.get(Uri.parse(apiUrl));

    if (reponse.statusCode == 200) {
      Map<String, dynamic> meteoData = json.decode(reponse.body);
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

  // popup avec les informations supplementaire de la tache
  Future<void> _infoDialog() async {
    // pour la carte
    double lat = _task.address != null ? _task.address!.lat : 0.0;
    double long = _task.address != null ? _task.address!.long : 0.0;

    if (_task.address != null) {
      _obtenirMeteo(_task.address!.city);
    }
    // la section meteo
    Widget sectionMeteo = Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Column(
                children: [
                  Text("${_tempActuelle ?? "_"}°C"),
                  const Text("Actuelle"),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("${_tempMin ?? "_"}°C"),
                        const Text("Min"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("${_tempMax ?? "_"}°C"),
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
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Text(_tempDescription ?? ""),
            ],
          ),
        ),
      ],
    );
    // popup design
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Colors.green,
          title: const Center(
            child: Text('Information'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'Tache',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_task.content),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(dateToString(_task.dateEnd)),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Adresse',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _task.address != null
                      ? _task.address.toString()
                      : "Pas d'adresse indiquer",
                ),
                SizedBox(
                  height: 150,
                  width: 50,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(lat, long),
                      initialZoom: 7,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                              point: LatLng(lat, long),
                              child: const Icon(
                                Icons.location_on,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                sectionMeteo,
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_task.description ?? "Pas de description"),
              ],
            ),
          ),
        );
      },
    );
  }

  // construction de la forme de l'item
  @override
  Widget build(BuildContext context) {
    // couleurs utils
    Color? colorSubTitle = Colors.grey[500];
    Color? colorIcon = _task.isFinish ? colorSubTitle : Colors.yellow;
    return GestureDetector(
      onTap: () {
        // direction pour modifier la tache
        Navigator.pushNamed(context, AddEditPage.nameRoute, arguments: _task.id);
      },
      onDoubleTap: () {
        // terminer la tache
        setState(() {
          _task.isFinish = true;
        });
      },
      // forme de la tache
      child: Card(
        elevation: 0,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _task.isPrio = !_task.isPrio;
                });
              },
              icon: _task.isPrio
                  ? Icon(
                      Icons.star,
                      color: colorIcon,
                    )
                  : Icon(
                      Icons.star_border,
                      color: colorIcon,
                    ),
            ),
            Checkbox(
              value: _task.isFinish,
              activeColor: colorSubTitle,
              onChanged: (value) {
                setState(() {
                  _task.isFinish = value!;
                  colorIcon = _task.isFinish ? colorSubTitle : Colors.yellow;
                });
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _task.content,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _task.isFinish ? colorSubTitle : Colors.black,
                    ),
                  ),
                  Text(
                    dateToString(_task.dateEnd),
                    style: TextStyle(
                      color: colorSubTitle,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _infoDialog,
              icon: Icon(
                Icons.info,
                color: _task.isFinish ? colorSubTitle : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
