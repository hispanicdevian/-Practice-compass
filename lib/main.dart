import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double azimuth = 0.0;
  StreamSubscription? sensorSubscription;

  @override
  void initState() {
    super.initState();
    startListening();
  }

  @override
  void dispose() {
    sensorSubscription?.cancel();
    super.dispose();
  }

  void startListening() {
    sensorSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        azimuth = _calculateAzimuth(event);
      });
    });
  }

  double _calculateAzimuth(AccelerometerEvent event) {
    final double x = event.x;
    final double y = event.y;
    final double z = event.z;

    final double radians = math.atan2(-x, math.sqrt(y * y + z * z));

    return radians * (180 / math.pi);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Compass'),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20.0),
            child: Transform.rotate(
              angle: math.pi + math.pi / 2 - azimuth * (math.pi / 180), // Add 180 degrees to the angle
              child: Image.asset(
                'images/featherNorth.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
