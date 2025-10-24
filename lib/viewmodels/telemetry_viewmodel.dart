import 'package:flutter/material.dart';
import '../models/telemetry_model.dart';
import '../services/telemetry_service.dart';

class TelemetryViewModel extends ChangeNotifier {
  final TelemetryService _service = TelemetryService();
  TelemetryData? _data;
  bool _tracking = false;

  TelemetryData? get data => _data;
  bool get isTracking => _tracking;

  void startTracking() {
    if (_tracking) return;
    _tracking = true;
    _service.start();
    _service.telemetryStream.listen((event) {
      _data = event;
      notifyListeners();
    });
  }

  void stopTracking() {
    _tracking = false;
    _service.stop();
    notifyListeners();
  }
}
