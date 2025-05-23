import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/operation_model.dart';

class TagRowsNotifier extends Notifier<List<TagRow>> {
  @override
  List<TagRow> build() {
    // Initialize with an empty list of rows
    return [];
  }

  // Function to add a new tag
  void addTag(TagRow newTag) {
    state = [...state, newTag]; // Append the new tag row to the list
  }
}

// Provider for managing rows
final tagRowsProvider =
    NotifierProvider<TagRowsNotifier, List<TagRow>>(TagRowsNotifier.new);

class TagRow {
  bool checkbox;
  File? image;
  String variant;
  String stockCode;
  double pcs;
  double wt;
  double netWt;
  double clsWt;
  double diaWt;
  double stoneAmt;
  double metalAmt;
  double wstg;
  double fixMrp;
  double making;
  double rate;
  double amount;
  String lineRemark;
  String huid;
  String orderVariant;
  double diaPieces;
 BomModel? bom;
  OperationModel? operation;

  TagRow(
      {this.checkbox = false,
      this.image = null,
      this.variant = '',
      this.stockCode = '',
      this.pcs = 0,
      this.wt = 0.0,
      this.netWt = 0.0,
      this.clsWt = 0.0,
      this.diaWt = 0.0,
      this.stoneAmt = 0.0,
      this.metalAmt = 0.0,
      this.wstg = 0.0,
      this.fixMrp = 0.0,
      this.making = 0.0,
      this.rate = 0.0,
      this.amount = 0.0,
      this.lineRemark = '',
      this.huid = '',
      this.orderVariant = '',
      this.diaPieces = 0,
      this.bom ,
      this.operation });
}

class IsTagUpdateNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // Initial value
  }

  void setUpdate(bool value) {
    state = value; // Update the state
  }
}

// Provider to manage the 'isUpdate' state
final isTagUpdateProvider = NotifierProvider<IsTagUpdateNotifier, bool>(
  IsTagUpdateNotifier.new,
);

class IsTagCreatedNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // Initial value
  }

  void setUpdate(bool value) {
    state = value; // Update the state
  }
}

// Provider to manage the 'isUpdate' state
final isTagCreatedProvider = NotifierProvider<IsTagCreatedNotifier, bool>(
  IsTagCreatedNotifier.new,
);

