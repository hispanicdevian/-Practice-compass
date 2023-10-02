import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Compass App'),
      ),
      body: const Center(
        child: Compass(),
      ),
    ),
  ));
}

class Compass extends StatefulWidget {
  const Compass({Key? key}) : super(key: key);

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  double azimuth = 0.0;
  double gyroAngle = 0.0;

  @override
  void initState() {
    super.initState();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        gyroAngle = calculateGyroAngle(event);
        azimuth = math.pi * 2 - math.pi / 180 * gyroAngle;
      });
    });
  }

  double calculateGyroAngle(GyroscopeEvent event) {
    // Use gyroscope data to calculate the orientation angle.
    // Apply filtering and integration techniques for better results.
    // This is a simplified calculation for demonstration.
    return gyroAngle + event.y / 100.0; // Adjust the scale as needed.
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: azimuth,
          child: Image.asset(
            'images/featherNorth.png', // Replace with your compass image path
            width: 200.0,
            height: 200.0,
          ),
        ),
        const SizedBox(height: 20.0),
        Text('Azimuth: ${(gyroAngle * 180 / math.pi).toStringAsFixed(2)}°'),
      ],
    );
  }
}
