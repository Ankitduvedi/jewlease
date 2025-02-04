import 'dart:developer';

import 'package:jewlease/data/hive_local_storage/model/location_model.dart';

import 'package:hive_flutter/hive_flutter.dart';

class LocationStorage {
  static const String locationsBox = 'locationsBox';
  static const String selectedLocationKey = 'selectedLocation';

  // ✅ Initialize Hive & open the box
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(locationsBox);
  }

  // ✅ Open the box before accessing data
  static Future<Box<dynamic>> _getBox() async {
    return await Hive.openBox<dynamic>(locationsBox);
  }

  static Future<void> saveLocations(List<Location> locations) async {
    final box = await _getBox();
    box.put('locations', locations.map((loc) => loc.toJson()).toList());
  }

  static List<Location> getLocations() {
    final box = Hive.box<dynamic>(locationsBox);
    final storedData = box.get('locations', defaultValue: []);

    if (storedData == null || storedData.isEmpty) return [];

    try {
      return (storedData as List)
          .map((json) => Location.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      log("Error parsing locations from Hive: $e");
      return [];
    }
  }

  static Future<void> saveSelectedLocation(Location location) async {
    final box = await _getBox();
    box.put(selectedLocationKey, location.toJson());
    log('Saved selected location: $location');
  }

  static Location? getSelectedLocation() {
    final box = Hive.box<dynamic>(locationsBox);
    final json = box.get(selectedLocationKey);
    return json != null
        ? Location.fromJson(Map<String, dynamic>.from(json))
        : null;
  }
}
