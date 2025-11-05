import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatelessWidget {
  final double totalDistance;
  final int visitCount;
  final DateTime date;
  final Duration totalDuration;
  final double averageSpeed;

  const StatisticsScreen({
    super.key,
    required this.totalDistance,
    required this.visitCount,
    required this.date,
    required this.totalDuration,
    required this.averageSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats for ${DateFormat.yMMMd().format(date)}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCard(
              icon: Icons.directions_walk,
              label: 'Total Distance',
              value: '${(totalDistance / 1000).toStringAsFixed(2)} km',
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              icon: Icons.location_on,
              label: 'Number of Visits',
              value: visitCount.toString(),
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              icon: Icons.timer,
              label: 'Total Duration',
              value: totalDuration.toString().split('.').first,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              icon: Icons.speed,
              label: 'Average Speed',
              value: '${averageSpeed.toStringAsFixed(2)} km/h',
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 22, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
