// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'location_bloc.dart';

class LocationState extends Equatable {
  final LocationStateStatus status;
  final double? latitude;
  final double? longitude;
  final Placemark? placemark;

  const LocationState({
    required this.status,
    this.latitude,
    this.longitude,
    this.placemark,
  });

  factory LocationState.initial() {
    return const LocationState(
      status: LocationStateStatus.initial,
    );
  }

  @override
  List<Object?> get props => [status, latitude, longitude, placemark];

  LocationState copyWith({
    LocationStateStatus? status,
    double? latitude,
    double? longitude,
    Placemark? placemark,
  }) {
    return LocationState(
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placemark: placemark ?? this.placemark,
    );
  }
}

enum LocationStateStatus {
  initial,
  loading,
  loaded,
  error,
}
