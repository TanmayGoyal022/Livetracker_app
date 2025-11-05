import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/services/tracking_service.dart';
import 'dart:async';

class MapTrackingScreen extends StatefulWidget {
  const MapTrackingScreen({super.key});

  @override
  State<MapTrackingScreen> createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends State<MapTrackingScreen> {
  final TrackingService _trackingService = TrackingService();
  final Completer<GoogleMapController> _controller = Completer();
  final List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _trackingService.startTracking((position) {
      final latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _routePoints.add(latLng);
      });
    });
  }

  @override
  void dispose() {
    _trackingService.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Tracking')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 15,
        ),
        markers: _routePoints.isNotEmpty
            ? {
                Marker(
                  markerId: const MarkerId('user'),
                  position: _routePoints.last,
                ),
              }
            : {},
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            points: _routePoints,
            color: Colors.blue,
            width: 5,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
