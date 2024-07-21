import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WeatherPredictionScreen(),
    );
  }
}

class WeatherPredictionScreen extends StatefulWidget {
  @override
  _WeatherPredictionScreenState createState() => _WeatherPredictionScreenState();
}

class _WeatherPredictionScreenState extends State<WeatherPredictionScreen> {
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController humidityController = TextEditingController();
  final TextEditingController windSpeedController = TextEditingController();
  String prediction = '';
  String weatherCondition = '';
  bool isLoading = false;
  String errorMessage = '';

  Future<void> predictWeather() async {
    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    // Validate inputs
    final temperature = double.tryParse(temperatureController.text);
    final humidity = double.tryParse(humidityController.text);
    final windSpeed = double.tryParse(windSpeedController.text);

    if (temperature == null || humidity == null || windSpeed == null) {
      setState(() {
        errorMessage = 'Please enter valid numeric values for all fields.';
        isLoading = false;
      });
      return;
    }

    if (temperature < -50 || temperature > 60) {
      setState(() {
        errorMessage = 'Temperature must be between -50 and 60.';
        isLoading = false;
      });
      return;
    }

    if (humidity < 0 || humidity > 100) {
      setState(() {
        errorMessage = 'Humidity must be between 0 and 100.';
        isLoading = false;
      });
      return;
    }

    if (windSpeed < 0 || windSpeed > 150) {
      setState(() {
        errorMessage = 'Wind Speed must be between 0 and 150.';
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://fastapi-mi8f.onrender.com/predict'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'temperature': temperature,
          'humidity': humidity,
          'wind_speed': windSpeed,
        }),
      );

      if (response.statusCode == 200) {
        double predictionValue = jsonDecode(response.body)['prediction'];
        setState(() {
          prediction = predictionValue.toStringAsFixed(2);
          weatherCondition = getWeatherCondition(predictionValue);
        });
      } else {
        setState(() {
          prediction = 'Error: Unable to predict';
          weatherCondition = '';
        });
      }
    } catch (e) {
      setState(() {
        prediction = 'Error: ${e.toString()}';
        weatherCondition = '';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getWeatherCondition(double predictionValue) {
    if (predictionValue < 0.5) {
      return 'Clear';
    } else if (predictionValue < 1.35) {
      return 'Sunny';
    } else if (predictionValue < 1.8) {
      return 'Cloudy';
    } else if (predictionValue < 2.3) {
      return 'Rainy';
    } else {
      return 'Stormy';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 50),
            Text(
              'Weather Prediction',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            if (errorMessage.isNotEmpty)
              Card(
                color: Colors.redAccent,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (!isLoading && prediction.isNotEmpty)
              Card(
                color: Colors.blueGrey,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Prediction: $prediction',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Weather Condition: $weatherCondition',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      getWeatherIcon(weatherCondition),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: Card(
                    color: Color(0xFF1E1E1E),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: temperatureController,
                        decoration: InputDecoration(
                          labelText: 'Temperature',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.thermostat),
                          filled: true,
                          fillColor: Color(0xFF2A2A2A),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Card(
                    color: Color(0xFF1E1E1E),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: humidityController,
                        decoration: InputDecoration(
                          labelText: 'Humidity',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.water_drop),
                          filled: true,
                          fillColor: Color(0xFF2A2A2A),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Card(
              color: Color(0xFF1E1E1E),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: windSpeedController,
                  decoration: InputDecoration(
                    labelText: 'Wind Speed',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.air),
                    filled: true,
                    fillColor: Color(0xFF2A2A2A),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: predictWeather,
                child: Text('Predict'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget getWeatherIcon(String condition) {
    switch (condition) {
      case 'Clear':
        return Icon(Icons.wb_sunny, size: 50, color: Colors.yellow);
      case 'Sunny':
        return Icon(Icons.wb_sunny_outlined, size: 50, color: Colors.orange);
      case 'Cloudy':
        return Icon(Icons.cloud, size: 50, color: Colors.grey);
      case 'Rainy':
        return Icon(Icons.umbrella, size: 50, color: Colors.blue);
      case 'Stormy':
        return Icon(Icons.thunderstorm, size: 50, color: Colors.black);
      default:
        return Icon(Icons.help_outline, size: 50, color: Colors.red);
    }
  }
}
