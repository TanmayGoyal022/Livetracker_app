import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking_app/core/services/local_data_service.dart';
import 'package:live_tracking_app/core/services/realtime_service.dart';
import 'package:live_tracking_app/core/utils/location.utils.dart';
import 'package:live_tracking_app/data/repositories/permission_repository.dart';
import 'package:live_tracking_app/data/repositories/tracking_repository.dart';
import 'package:live_tracking_app/presentation/cubits/history_cubit.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit(
        PermissionRepository(),
        TrackingRepository(
          RealtimeService(),
          LocationUtils(),
          LocalDataService(),
        ),
      )..checkForPendingLocations(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
        ),
        body: BlocConsumer<HistoryCubit, HistoryState>(
          listener: (context, state) {
            if (state is HistoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is HistoryInitial || state is HistoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is HistoryNeedsRetry) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<HistoryCubit>().retry();
                  },
                  child: const Text('Retry'),
                ),
              );
            }
            if (state is HistoryPermissionGranted ||
                state is HistoryTrackingStopped) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<HistoryCubit>().startTracking();
                  },
                  child: const Text('Start Tracking'),
                ),
              );
            }
            if (state is HistoryTrackingStarted) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<HistoryCubit>().stopTracking();
                  },
                  child: const Text('Stop Tracking'),
                ),
              );
            }
            if (state is HistoryPermissionDenied) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Location permission denied.'),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<HistoryCubit>()
                            .requestLocationPermission();
                      },
                      child: const Text('Grant Permission'),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<HistoryCubit>().requestLocationPermission();
                },
                child: const Text('Grant Location Permission'),
              ),
            );
          },
        ),
      ),
    );
  }
}
