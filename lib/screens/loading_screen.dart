import 'dart:convert';
import 'dart:io';

import 'package:clima/services/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;

const apiKey = '';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _latitude;
  double _longitude;

  @override
  void initState() {
    super.initState();

    getLocation();
  }

  void getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    setState(() {
      _latitude = location.latitude;
      _longitude = location.longitude;
    });
  }

  void getData() async {
    Http.Response response = await Http.get(
        'http://api.openweathermap.org/data/2.5/weather?lat=$_latitude&lon=$_longitude&appid=$apiKey');

    if (response.statusCode == HttpStatus.ok) {
      var data = jsonDecode(response.body);

      var weather = {
        'cond': data['weather'][0]['id'],
        'name': data['name'],
        'temp': data['main']['temp'],
      };

      print(weather);
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            //Get the current location
            getData();
          },
          child: Text('Get Location'),
        ),
      ),
    );
  }
}
