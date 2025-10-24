import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/telemetry_viewmodel.dart';
import 'views/telemetry_screen.dart';

void main() {
  runApp(const TelemetryApp());
}

class TelemetryApp extends StatelessWidget {
  const TelemetryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TelemetryViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Telemetry App',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        home: const TelemetryScreen(),
      ),
    );
  }
}
