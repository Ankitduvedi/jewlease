// item_controller.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/repository/item_configuration_repository.dart';

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final dio = Dio(); // You might want to configure Dio further if needed
  return ItemRepository(dio);
});

final itemTypeFutureProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.read(itemRepositoryProvider);
  return await repository.fetchItemType();
});

final itemGroupFutureProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.read(itemRepositoryProvider);
  return await repository.fetchItemGroup();
});
