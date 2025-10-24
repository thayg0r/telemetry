import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../viewmodels/telemetry_viewmodel.dart';

class TelemetryScreen extends StatefulWidget {
  const TelemetryScreen({super.key});

  @override
  State<TelemetryScreen> createState() => _TelemetryScreenState();
}

class _TelemetryScreenState extends State<TelemetryScreen> {
  GoogleMapController? _mapController;
  bool _isMapReady = false;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TelemetryViewModel>();
    final data = vm.data;

    final LatLng currentPos = data != null
        ? LatLng(data.latitude, data.longitude)
        : const LatLng(-23.5505, -46.6333);

    if (_isMapReady && data != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(currentPos));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Telemetria em Tempo Real',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              setState(() => _isMapReady = true);
            },
            myLocationEnabled: vm.isTracking,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: currentPos, zoom: 16),
            markers: data != null
                ? {
                    Marker(
                      markerId: const MarkerId('pos'),
                      position: currentPos,
                      infoWindow: InfoWindow(
                        title:
                            "Velocidade: ${(data.speed * 3.6).toStringAsFixed(1)} km/h",
                      ),
                    )
                  }
                : {},
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _InfoTile(
                    label: 'Velocidade',
                    value: data != null
                        ? '${(data.speed * 3.6).toStringAsFixed(1)} km/h'
                        : '--',
                    icon: Icons.speed,
                    color: Colors.cyanAccent,
                  ),
                  _InfoTile(
                    label: 'Aceleração',
                    value: data != null
                        ? data.acceleration
                            .map((e) => e.toStringAsFixed(2))
                            .join(', ')
                        : '--',
                    icon: Icons.show_chart,
                    color: Colors.orangeAccent,
                  ),
                  _InfoTile(
                    label: 'Direção',
                    value: data != null
                        ? '${data.heading.toStringAsFixed(1)}°'
                        : '--',
                    icon: Icons.explore,
                    color: Colors.purpleAccent,
                  ),
                  const SizedBox(height: 14),

                  ElevatedButton.icon(
                    onPressed:
                        vm.isTracking ? vm.stopTracking : vm.startTracking,
                    icon: Icon(
                      vm.isTracking ? Icons.stop : Icons.play_arrow_rounded,
                      size: 26,
                    ),
                    label: Text(
                      vm.isTracking
                          ? 'Parar Monitoramento'
                          : 'Iniciar Monitoramento',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vm.isTracking
                          ? Colors.redAccent
                          : Colors.greenAccent.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
