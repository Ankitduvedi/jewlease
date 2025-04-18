// Define a provider to manage the state of the selected master type
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/formula_mapping_model.dart';
import 'package:jewlease/data/model/formula_model.dart';
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

  Future<void> addRangeMasterDepdField(Map<String, dynamic> requestBody,
      BuildContext context) async {
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

  Future<List<Map<String, dynamic>>> fetchRangeMasterList(String heirarchyName,
      String rangeType) async {
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

  Future<void> addRangeMasterExcel(Map<String, dynamic> reqBody,
      BuildContext context) async {
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

  Future<Map<dynamic, dynamic>> fetchRangeMasterExcel(String hierarchyName,
      BuildContext context) async {
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

  Future<void> addFormulaExcel(Map<String, dynamic> reqBody,
      BuildContext context) async {
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

  Future<Map<String, dynamic>> fetchFormulaExcel(String formulaProcedureName,
      BuildContext context) async {
    try {
      state = true;
      final response = await _formulaProcedureRepository
          .fetchFormulaExcel(formulaProcedureName);
      state = false;

      return response;

      // Optionally update the state if necessary after submission
    } catch (e) {
      print("erro in fetching formula excel $e ");
      state = false;
    }
    return {};
  }

  Future<Map<String, dynamic>> fetchFormulaByAttribute(
      Map<String, dynamic>attributes, BuildContext context) async {
    try {
      state = true;
      final response = await _formulaProcedureRepository
          .fetchFormulaByAttribute(attributes);
      state = false;

      return response;

      // Optionally update the state if necessary after submission
    } catch (e) {
      print("erro in fetching formula excel $e ");
      state = false;
    }
    return {};
  }

  Future<Map<dynamic, dynamic>> fetchRangeExcel(String rangehHierarchyName,
      BuildContext context) async {
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

  Future<void> addFormulaMapping(FormulaMappigModel config,
      BuildContext context) async {
    try {
      state = true;

      final response =
      await _formulaProcedureRepository.addFormulaMapping(config);
      state = false;
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        log('entered in the fold');

        Utils.snackBar('Formula Mapping Added', context);
        context.pop();
        null;
      });
      // Optionally update the state if necessary after submission
    } catch (e) {
      log('entered in the error');

      state = false;
    }
  }

  Future<String?> getFormulaId(FormulaModel formula, BuildContext context) async {
    try {
      state = true;

      List<Map<String, dynamic>>formulaRows = formula.formulaRows.map((row) =>
          row.toJson()).toList();

      final String? response =
      await _formulaProcedureRepository.getFormulaId(formulaRows);
      return response;
      state = false;
      // Optionally update the state if necessary after submission
    } catch (e) {
      log('entered in the error');

      state = false;
    }
  }


}

// Define a provider for the controller
final formulaProcedureControllerProvider =
StateNotifierProvider<formulaProcedureController, bool>((ref) {
  final dio = Dio();
  final repository = formulaProcedureRepository(dio);
  return formulaProcedureController(repository);
});
