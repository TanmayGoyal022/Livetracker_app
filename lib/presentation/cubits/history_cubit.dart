import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking_app/data/repositories/permission_repository.dart';
import 'package:live_tracking_app/data/repositories/tracking_repository.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryPermissionGranted extends HistoryState {}

class HistoryPermissionDenied extends HistoryState {}

class HistoryTrackingStarted extends HistoryState {}

class HistoryTrackingStopped extends HistoryState {}

class HistoryNeedsRetry extends HistoryState {}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}

class HistoryCubit extends Cubit<HistoryState> {
  final PermissionRepository _permissionRepository;
  final TrackingRepository _trackingRepository;

  HistoryCubit(this._permissionRepository, this._trackingRepository)
      : super(HistoryInitial());

  void requestLocationPermission() async {
    emit(HistoryLoading());
    final isGranted = await _permissionRepository.requestLocationPermission();
    if (isGranted) {
      emit(HistoryPermissionGranted());
    } else {
      emit(HistoryPermissionDenied());
    }
  }

  void startTracking() {
    _trackingRepository.startTracking();
    emit(HistoryTrackingStarted());
  }

  void stopTracking() {
    _trackingRepository.stopTracking();
    emit(HistoryTrackingStopped());
  }

  void checkForPendingLocations() {
    // This is a placeholder. In a real app, you would check the local
    // database for pending locations.
    final hasPendingLocations = false;
    if (hasPendingLocations) {
      emit(HistoryNeedsRetry());
    }
  }

  void retry() async {
    emit(HistoryLoading());
    try {
      await _trackingRepository.retry();
      emit(HistoryPermissionGranted());
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
