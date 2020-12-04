import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/utilities/constants.dart';
import 'package:weather_app/modules/elevated_icon_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/utilities/weather_data.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  String cityName = '';
  String weatherIcon = '';
  String userInput = '';
  Weather weather;
  WeatherFactory weatherFactory;

  void updateUI() {
    if (weather == null) {
      setState(() {
        temp = 404;
        cityName = 'Error';
        weatherIcon = 'E';
      });
      return;
    }

    setState(() {
      temp = weather.temperature.celsius;
      cityName = weather.areaName;
      weatherIcon = WeatherData.getWeatherIcon(weather.weatherConditionCode);
    });
  }

  @override
  void initState() {
    weatherFactory = WeatherFactory('13f6b010b8fca72f81754571d05c160f');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.blue[700],
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              cityName,
                              style: TextStyle(fontSize: 40.0),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                weatherIcon,
                                style: TextStyle(fontSize: 150.0),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${temp.round()} °C',
                                style: TextStyle(fontSize: 35.0),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ElevatedIconButton(
                          //Hae säätiedot nykyisen paikan mukaan
                          icon: Icons.location_on,
                          onPressed: () async {
                            Position position =
                                await Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.low);
                            print(position);
                            weather =
                                await weatherFactory.currentWeatherByLocation(
                                    position.latitude, position.longitude);
                            updateUI();
                          },
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            decoration: kInputFieldDecoration,
                            onChanged: (inputText) {
                              userInput = inputText;
                            },
                            onSubmitted: (inputText) async {
                              weather = await weatherFactory
                                  .currentWeatherByCityName(inputText);
                              updateUI();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        ElevatedIconButton(
                          //Hae säätiedot kirjoitetun paikannimen mukaan
                          icon: Icons.search,
                          onPressed: () async {
                            weather = await weatherFactory
                                .currentWeatherByCityName(userInput);
                            updateUI();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
