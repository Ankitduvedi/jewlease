// Define a provider to manage the state of the selected master type
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/item_master_metal.dart';
import 'package:jewlease/feature/formula/repository/formula_Procedue_repository.dart';

final formulaProcedureProvider =
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

// Create a StateNotifier for managing the state and interactions
class formulaProcedureController extends StateNotifier<bool> {
  final formulaProcedureRepository _formulaProcedureRepository;

  formulaProcedureController(this._formulaProcedureRepository) : super(false);

  Future<void> addRangeMasterDepdField(
      Map<String, dynamic> requestBody, BuildContext context) async {
    try {
      state = true;
      final response = await _formulaProcedureRepository
          .addRangeMasterDepdField(requestBody);
      state = false;

      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Range Masster Addded', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      print("error range name $e");
      state = false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchRangeMasterList(
      String heirarchyName, String rangeType) async {
    try {
      state = true;
      final response = await _formulaProcedureRepository
          .fetchRangeMasterDepdField(heirarchyName, '');
      state = false;
      List<Map<String, dynamic>> responseList = [];
      response.forEach((element) {
        responseList.add(element);
      });
      print("fetchRangeMasterList response is $response");
      return responseList;
    } catch (e) {
      state = false;
    }
    return [];
  }

  Future<void> addRangeMasterExcel(
      Map<String, dynamic> reqBody, BuildContext context) async {
    try {
      state = true;
      final response =
          await _formulaProcedureRepository.addRangeMasterExcel(reqBody);
      state = false;

      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Range Masster Excel Addded', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      print("error range excel $e");
      state = false;
    }
  }

  Future<Map<dynamic, dynamic>> fetchRangeMasterExcel(
      String hierarchyName, BuildContext context) async {
    try {
      state = true;
      final response = await _formulaProcedureRepository
          .fetchRangeMasterExcel(hierarchyName);
      state = false;
      print("fetchRangeMasterexcel response is $response");
      return response;

      // Optionally update the state if necessary after submission
    } catch (e) {
      print("erro in fetching ");
      state = false;
    }
    return {};
  }

  Future<void> addFormulaExcel(
      Map<String, dynamic> reqBody, BuildContext context) async {
    try {
      state = true;
      final response =
          await _formulaProcedureRepository.addFormulaExcel(reqBody);
      state = false;

      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        Utils.snackBar('New Range Masster Excel Addded', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      state = false;
    }
  }

  Future<Map<String, dynamic>> fetchFormulaExcel(
      String formulaProcedureName, BuildContext context) async {
    try {
      state = true;
      final response = await _formulaProcedureRepository
          .fetchFormulaExcel(formulaProcedureName);
      state = false;
      print(" formula excel response is $response");
      return response;

      // Optionally update the state if necessary after submission
    } catch (e) {
      print("erro in fetching formula excel $e ");
      state = false;
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> fetchRangeExcel(
      String rangehHierarchyName, BuildContext context) async {
    try {
      state = true;
      final response = await _formulaProcedureRepository
          .fetchRangeMasterExcel(rangehHierarchyName);
      state = false;
      print(" range excel response is $response");
      return response;

      // Optionally update the state if necessary after submission
    } catch (e) {
      print("error in fetching $e ");
      state = false;
    }
    return {};
  }
}

// Define a provider for the controller
final formulaProcedureControllerProvider =
    StateNotifierProvider<formulaProcedureController, bool>((ref) {
  final dio = Dio();
  final repository = formulaProcedureRepository(dio);
  return formulaProcedureController(repository);
});
