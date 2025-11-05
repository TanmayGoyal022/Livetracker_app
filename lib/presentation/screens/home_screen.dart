import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_tracking_app/core/utils/map_utils.dart';
import 'package:live_tracking_app/presentation/screens/login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:live_tracking_app/presentation/screens/statistics_screen.dart';
import 'package:live_tracking_app/presentation/widgets/animation_control_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  List<LatLng> _locations = [];
  final Set<Marker> _markers = {};
  DateTime _selectedDate = DateTime.now();
  BitmapDescriptor? _customMarker;
  Timer? _animationTimer;
  int _animationIndex = 0;
  Marker? _animatedMarker;
  bool _isAnimating = false;
  bool _isPaused = false;
  List<Map<String, dynamic>> _locationData = [];

  @override
  void initState() {
    super.initState();
    _createCustomMarker();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  void _createCustomMarker() async {
    _customMarker = await MapUtils.createCustomMarkerFromIcon(
      Icons.location_pin,
    );
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleAnimation() {
    if (_isAnimating && !_isPaused) {
      _pauseAnimation();
    } else {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (_locations.isEmpty) return;

    setState(() {
      _isAnimating = true;
      _isPaused = false;
    });

    _animationTimer?.cancel();
    if (_animationIndex >= _locations.length - 1) {
      _animationIndex = 0;
    }

    _animationTimer = Timer.periodic(const Duration(milliseconds: 200), (
      timer,
    ) {
      if (_animationIndex < _locations.length) {
        setState(() {
          _animatedMarker = Marker(
            markerId: const MarkerId('animated_marker'),
            position: _locations[_animationIndex],
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          );
        });
        _animationIndex++;
      } else {
        _stopAnimation();
      }
    });
  }

  void _pauseAnimation() {
    _animationTimer?.cancel();
    setState(() {
      _isPaused = true;
    });
  }

  void _stopAnimation() {
    _animationTimer?.cancel();
    setState(() {
      _isAnimating = false;
      _isPaused = false;
      _animatedMarker = null;
      _animationIndex = 0;
    });
  }

  Map<String, dynamic> _calculateStatistics() {
    double totalDistance = 0;
    Duration totalDuration = Duration.zero;

    if (_locationData.length > 1) {
      for (int i = 0; i < _locationData.length - 1; i++) {
        totalDistance += Geolocator.distanceBetween(
          _locationData[i]['latitude'],
          _locationData[i]['longitude'],
          _locationData[i + 1]['latitude'],
          _locationData[i + 1]['longitude'],
        );
      }
      totalDuration = (_locationData.last['timestamp'] as Timestamp)
          .toDate()
          .difference((_locationData.first['timestamp'] as Timestamp).toDate());
    }

    double averageSpeed = 0;
    if (totalDuration.inHours > 0) {
      averageSpeed = (totalDistance / 1000) / totalDuration.inHours;
    }

    return {
      'totalDistance': totalDistance,
      'totalDuration': totalDuration,
      'averageSpeed': averageSpeed,
    };
  }

  Future<void> _showNameVisitDialog(String visitId) async {
    final nameController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Name this Visit'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter a name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                _updateVisitName(visitId, nameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateVisitName(String visitId, String name) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final date =
          '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
      FirebaseFirestore.instance
          .collection('tracks')
          .doc(user.uid)
          .collection('daily')
          .doc(date)
          .collection('visits')
          .doc(visitId)
          .update({'name': name});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.yMMMd().format(_selectedDate)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              final stats = _calculateStatistics();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatisticsScreen(
                    totalDistance: stats['totalDistance'],
                    visitCount: _markers.length,
                    date: _selectedDate,
                    totalDuration: stats['totalDuration'],
                    averageSpeed: stats['averageSpeed'],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              if (!mounted) return;
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _getLocationsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _locationData = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();
                _locations = _locationData
                    .map((data) => LatLng(data['latitude'], data['longitude']))
                    .toList();

                if (_locations.isNotEmpty && _mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngBounds(
                      _createBounds(_locations),
                      50.0,
                    ),
                  );
                }
              }

              return GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 2,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  if (_locations.isNotEmpty) {
                    _mapController!.animateCamera(
                      CameraUpdate.newLatLngBounds(
                        _createBounds(_locations),
                        50.0,
                      ),
                    );
                  }
                },
                polylines: {
                  if (_locations.isNotEmpty)
                    Polyline(
                      polylineId: const PolylineId('track'),
                      points: _locations,
                      color: Colors.blue,
                      width: 5,
                    ),
                },
                markers: _animatedMarker != null
                    ? _markers.union({_animatedMarker!})
                    : _markers,
              );
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _getVisitsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _updateMarkers(snapshot.data!.docs);
              }
              return const SizedBox.shrink();
            },
          ),
          if (_isAnimating)
            AnimationControlPanel(
              isAnimating: _isAnimating,
              isPaused: _isPaused,
              onToggle: _toggleAnimation,
              onStop: _stopAnimation,
            ),
        ],
      ),
      floatingActionButton: _locations.isNotEmpty && !_isAnimating
          ? FloatingActionButton(
              onPressed: _toggleAnimation,
              child: const Icon(Icons.play_arrow),
            )
          : null,
    );
  }

  void _updateMarkers(List<QueryDocumentSnapshot> docs) async {
    _markers.clear();
    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final startTime = (data['startTime'] as Timestamp).toDate();
      final endTime = (data['endTime'] as Timestamp).toDate();
      final formattedStartTime = DateFormat.jm().format(startTime);
      final formattedEndTime = DateFormat.jm().format(endTime);
      final visitName = data['name'] as String?;

      final placemarks = await placemarkFromCoordinates(
        data['latitude'],
        data['longitude'],
      );
      final address = placemarks.isNotEmpty
          ? placemarks.first.name
          : 'Unknown Location';

      if (mounted) {
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(data['latitude'], data['longitude']),
              icon: _customMarker ?? BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(
                title: visitName ?? address,
                snippet: '$formattedStartTime - $formattedEndTime',
                onTap: () => _showNameVisitDialog(doc.id),
              ),
            ),
          );
        });
      }
    }
  }

  Stream<QuerySnapshot> _getLocationsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final date =
          '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';

      return FirebaseFirestore.instance
          .collection('tracks')
          .doc(user.uid)
          .collection('daily')
          .doc(date)
          .collection('locations')
          .orderBy('timestamp')
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  Stream<QuerySnapshot> _getVisitsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final date =
          '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';

      return FirebaseFirestore.instance
          .collection('tracks')
          .doc(user.uid)
          .collection('daily')
          .doc(date)
          .collection('visits')
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwest = positions.reduce((v, e) {
      return LatLng(
        v.latitude < e.latitude ? v.latitude : e.latitude,
        v.longitude < e.longitude ? v.longitude : e.longitude,
      );
    });
    final northeast = positions.reduce((v, e) {
      return LatLng(
        v.latitude > e.latitude ? v.latitude : e.latitude,
        v.longitude > e.longitude ? v.longitude : e.longitude,
      );
    });
    return LatLngBounds(southwest: southwest, northeast: northeast);
  }
}
