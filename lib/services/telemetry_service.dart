import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/telemetry_model.dart';

class TelemetryService {
  StreamSubscription<Position>? _posStream;
  StreamSubscription<AccelerometerEvent>? _accelStream;

  final _controller = StreamController<TelemetryData>.broadcast();
  Stream<TelemetryData> get telemetryStream => _controller.stream;

  Future<void> start() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    List<double> accel = [0, 0, 0];

    _posStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ),
    ).listen((pos) {
      _controller.add(TelemetryData(
        latitude: pos.latitude,
        longitude: pos.longitude,
        speed: pos.speed,
        heading: pos.heading,
        acceleration: accel,
      ));
    });

    _accelStream = accelerometerEvents.listen((event) {
      accel = [event.x, event.y, event.z];
    });
  }

  void stop() {
    _posStream?.cancel();
    _accelStream?.cancel();
  }
}
