class TelemetryData {
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final List<double> acceleration;

  TelemetryData({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.acceleration,
  });

  TelemetryData copyWith({
    double? latitude,
    double? longitude,
    double? speed,
    double? heading,
    List<double>? acceleration,
  }) {
    return TelemetryData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      acceleration: acceleration ?? this.acceleration,
    );
  }
}
