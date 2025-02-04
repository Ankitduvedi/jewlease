import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:jewlease/data/hive_local_storage/manager/location_storage.dart';
import 'dart:developer';
import 'package:jewlease/data/hive_local_storage/model/location_model.dart';

class DrawerRepository {
  // Fetch data for dropdowns
  Future<List<String>> fetchCompanies() async {
    // Simulate API call
    return Future.value(['Company A', 'Company B']);
  }

  Future<List<String>> fetchLocations() async {
    return Future.value(['Location A', 'Location B']);
  }

  // Add other repository methods for fetching or updating data
}

class LocationListNotifier extends StateNotifier<List<Location>> {
  final Dio _dio;
  final Ref _ref; // ✅ Added ref to access selectedLocationProvider

  LocationListNotifier(this._dio, this._ref) : super([]) {
    log('LocationListNotifier');
    loadLocations();
  }

  Future<void> loadLocations() async {
    log('IN LOAD LOCATION');
    final storedLocations = LocationStorage.getLocations();
    log('LOADED LOCATION ${storedLocations.length} locations');

    if (storedLocations.isNotEmpty) {
      state = storedLocations;
      log("Loaded ${state.length} locations from Hive.");
    }
    await fetchLocations(); // Always fetch latest
  }

  Future<void> fetchLocations() async {
    try {
      log("Fetching locations...");
      final response =
          await _dio.get('http://13.203.104.205:3000/Global/Location');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final fetchedLocations = data
            .map((json) => Location.fromJson(json as Map<String, dynamic>))
            .toList();

        if (_shouldUpdateHive(fetchedLocations)) {
          state = fetchedLocations;
          await LocationStorage.saveLocations(fetchedLocations);
          log("Fetched and updated ${state.length} locations.");

          // ✅ Ensure selected location exists in the new list
          final selectedLoc = LocationStorage.getSelectedLocation();
          if (selectedLoc == null ||
              !fetchedLocations
                  .any((loc) => loc.locationCode == selectedLoc.locationCode)) {
            _ref
                .read(selectedLocationProvider.notifier)
                .setSelectedLocation(fetchedLocations.first);
          }
        } else {
          log("No changes detected in locations.");
        }
      }
    } catch (e) {
      log("Error fetching locations: $e");
    }
  }

  bool _shouldUpdateHive(List<Location> newLocations) {
    final existingLocations = LocationStorage.getLocations();
    if (existingLocations.length != newLocations.length) return true;

    for (int i = 0; i < existingLocations.length; i++) {
      if (existingLocations[i].toJson().toString() !=
          newLocations[i].toJson().toString()) {
        return true;
      }
    }
    return false;
  }
}

class SelectedLocationNotifier extends StateNotifier<Location?> {
  SelectedLocationNotifier() : super(null) {
    _loadSelectedLocation();
  }
  void _loadSelectedLocation() {
    final savedLocation = LocationStorage.getSelectedLocation();
    log('saved location ${savedLocation?.locationName}');

    if (savedLocation != null) {
      state = savedLocation; // ✅ Restore selected location
    } else {
      // ✅ Use first location if no valid saved one
      LocationStorage.saveSelectedLocation(state!);
    }
  }

  void setSelectedLocation(Location newLocation) {
    state = newLocation;
    log('new location ${newLocation.locationName}');
    LocationStorage.saveSelectedLocation(newLocation);
  }
}

// ✅ Updated Providers
final locationListProvider =
    StateNotifierProvider<LocationListNotifier, List<Location>>((ref) {
  final dio = Dio();
  log('LocationListNotifier provider');
  return LocationListNotifier(dio, ref);
});

final selectedLocationProvider =
    StateNotifierProvider<SelectedLocationNotifier, Location?>((ref) {
  log('SelectedLocationNotifier provider');
  return SelectedLocationNotifier();
});
