import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState.initial()) {
    on<GetCurrentLocation>((event, emit) async {
      emit(state.copyWith(status: LocationStateStatus.loading));
      const String countryCode = "th";

      final Position currentPositon = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );  

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPositon.latitude,
          currentPositon.longitude,
          localeIdentifier: countryCode,
        );
        if (placemarks.isNotEmpty) {
          final Placemark placemark = placemarks.first;
          emit(state.copyWith(
            status: LocationStateStatus.loaded,
            latitude: currentPositon.latitude,
            longitude: currentPositon.longitude,
            placemark: placemark,
          ));
        }
      } catch (error) {
        log("$error", error: error);
        emit(state.copyWith(status: LocationStateStatus.error));
      }
    });
  }
}
