// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final locationFutureProvider =
//     FutureProvider.family<List<Map<String, dynamic>>, String>(
//         (ref, parameter) async {
//   final repository = ref.read(itemRepositoryProvider);
//   return await repository.fetchItemType(parameter);
// });
// import 'dart:convert';
// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:jewlease/data/model/location_model.dart';

// class LocationRepository {
//   final Dio _dio;
//   LocationRepository(this._dio);
//   Future<List<Location>> fetchLocations() async {
//     log("fetching locations");
//     final response =
//         await _dio.get('http://13.203.104.205:3000/Global/Location');
//     log("fetched locations");
//     final data = (response.data as List)
//         .map((json) => Location.fromJson(json as Map<String, dynamic>))
//         .toList();
//     log('ting ${data[1].locationName}');

//     return (response.data as List)
//         .map((json) => Location.fromJson(json as Map<String, dynamic>))
//         .toList();
//   }
// }

