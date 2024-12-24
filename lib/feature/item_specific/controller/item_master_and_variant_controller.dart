// Define a provider to manage the state of the selected master type
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/item_master_metal.dart';
import 'package:jewlease/data/model/item_master_stone.dart';
import 'package:jewlease/data/model/style_item_model.dart';
import 'package:jewlease/data/model/style_variant_model.dart';
import 'package:jewlease/data/model/variant_master_metal.dart';
import 'package:jewlease/data/model/variant_master_stone.dart';
import 'package:jewlease/feature/item_specific/repository/item_configuration_repository.dart';
import 'package:jewlease/providers/image_provider.dart';
import 'package:jewlease/widgets/image_data.dart';

final masterTypeProvider =
    StateProvider<List<String?>>((ref) => ['Style', null, null]);
// Define a provider for the checkbox state
final checkboxProvider = StateProvider<bool>((ref) => false);

final selectedMetalDataProvider = StateProvider<ItemMasterMetal>((ref) =>
    ItemMasterMetal(
        metalCode: 'test',
        exclusiveIndicator: false,
        description: '',
        rowStatus: '',
        createdDate: DateTime.now(),
        updateDate: DateTime.now(),
        attributeType: '',
        attributeValue: ''));

final selectedStoneItemDataProvider = StateProvider<ItemMasterStone>((ref) =>
    ItemMasterStone(
        stoneCode: '',
        description: '',
        rowStatus: '',
        createdDate: DateTime(2024),
        updateDate: DateTime(2024),
        attributeType: '',
        attributeValue: ''));

// Create a StateNotifier for managing the state and interactions
class ItemSpecificController extends StateNotifier<bool> {
  final ItemSpecificRepository _itemSpecificRepository;

  ItemSpecificController(
    this._itemSpecificRepository,
  ) : super(false);

  Future<void> submitMetalItemConfiguration(
      ItemMasterMetal config, BuildContext context, String metal) async {
    try {
      log('in controller');

      state = true;
      final response =
          await _itemSpecificRepository.addMetalItem(config, metal);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Metal Item Created', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      log('error');

      state = false;
    }
  }

  Future<void> submitStoneItemConfiguration(
      ItemMasterStone config, BuildContext context, String stone) async {
    try {
      log('in controller');

      state = true;
      final response =
          await _itemSpecificRepository.addStoneItem(config, stone);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Stone ($stone) Item Created', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      log('error');
      Utils.snackBar(e.toString(), context);
      state = false;
    }
  }

  Future<void> submitStoneVariantConfiguration(
      VariantMasterStone config, BuildContext context, String stone) async {
    try {
      log('in controller');
      state = true;
      final response =
          await _itemSpecificRepository.addStoneVariant(config, stone);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Stone ($stone) Variant Created', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      log('error');
      Utils.snackBar(e.toString(), context);
      state = false;
    }
  }

  Future<void> submitMetalVariantConfiguration(
      VariantMasterMetal config, BuildContext context, String metal) async {
    try {
      state = true;
      final response =
          await _itemSpecificRepository.addMetalVariant(config, metal);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Metal Variant Created', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      state = false;
    }
  }

  Future<void> submitStyleItemConfiguration(
      ItemMasterStyle config, BuildContext context, WidgetRef ref) async {
    try {
      state = true;
      List<ImageDetail> imageDetails = [];
      final List<ImageModel> images = ref.watch(imageProvider);
      for (ImageModel image in images) {
        log('image data ${image.description}');
        final response =
            await ref.watch(imageProvider.notifier).uploadImage(image);
        response.fold((l) => Utils.snackBar(l.message, context), (r) {
          ImageDetail imageDetail = ImageDetail(
              url: r,
              type: image.type,
              isDefault: image.isDefault,
              description: image.description);
          imageDetails.add(imageDetail);
        });
      }
      config.imageDetails = imageDetails;
      final response = await _itemSpecificRepository.addStyleItem(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Style Item Created', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      state = false;
    }
  }

  Future<void> submitStyleVariantConfiguration(
      ItemMasterVariant config, BuildContext context, WidgetRef ref) async {
    try {
      state = true;
      List<ImageDetail> imageDetails = [];
      final List<ImageModel> images = ref.watch(imageProvider);
      for (ImageModel image in images) {
        log('image data ${image.description}');
        final response =
            await ref.watch(imageProvider.notifier).uploadImage(image);
        response.fold((l) => Utils.snackBar(l.message, context), (r) {
          ImageDetail imageDetail = ImageDetail(
              url: r,
              type: image.type,
              isDefault: image.isDefault,
              description: image.description);
          imageDetails.add(imageDetail);
        });
      }
      config.imageDetails = imageDetails;
      log('config');
      final response = await _itemSpecificRepository.addStyleVariant(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Style Item Created', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      state = false;
    }
  }
}

// Define a provider for the controller
final itemSpecificControllerProvider =
    StateNotifierProvider<ItemSpecificController, bool>((ref) {
  final dio = Dio();
  final repository = ItemSpecificRepository(dio);
  return ItemSpecificController(repository);
});
