import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => "");

final filteredPagesProvider = Provider<List<SearchPage>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  if (query.isEmpty) return [];

  return searchablePages.where((page) {
    final name = page.name.toLowerCase();
    return name.startsWith(query); // Ensures continuous match
  }).toList();
});

class SearchPage {
  final String name;
  final String route;

  SearchPage({required this.name, required this.route});
}

final List<SearchPage> searchablePages = [
  SearchPage(name: "Home", route: "/"),
  SearchPage(name: "Department Home", route: "/departmentHomeScreen"),
  SearchPage(
      name: "Add Department",
      route: "/departmentHomeScreen/adddDepartmentScreen"),
  SearchPage(name: "Employee Home", route: "/employeeHomeScreen"),
  SearchPage(
      name: "Add Employee", route: "/employeeHomeScreen/addEmployeeScreen"),
  SearchPage(name: "Master", route: "/masterScreen"),
  // SearchPage(name: "Add Style Item", route: "/masterScreen/addStyleItemScreen"),
  // SearchPage(
  //     name: "Add Style Variant", route: "/masterScreen/addStyleVariantScreen"),
  // SearchPage(name: "Add Metal Item", route: "/masterScreen/addMetalItemScreen"),
  // SearchPage(name: "Add Stone Item", route: "/masterScreen/addStoneItemScreen"),
  // SearchPage(
  //     name: "Add Consumables Item",
  //     route: "/masterScreen/addConsumablesItemScreen"),
  // SearchPage(name: "Add Set Item", route: "/masterScreen/addSetItemScreen"),
  // SearchPage(
  //     name: "Add Certificate Item",
  //     route: "/masterScreen/addCertificateItemScreen"),
  // SearchPage(
  //     name: "Add Packing Material",
  //     route: "/masterScreen/addPackingMaterialItemScreen"),
  // SearchPage(
  //     name: "Add Metal Variant", route: "/masterScreen/addMetalVariantScreen"),
  // SearchPage(
  //     name: "Add Stone Variant", route: "/masterScreen/addStoneVariantScreen"),
  // SearchPage(
  //     name: "Item Master Gold", route: "/masterScreen/itemMasterGoldScreen"),
  // SearchPage(
  //     name: "Item Master Stone", route: "/masterScreen/itemMasterStoneScreen"),
  SearchPage(
      name: "Variant Master Gold",
      route: "/masterScreen/variantMasterGoldScreen"),
  SearchPage(name: "Item Configuration", route: "/itemConfigurationScreen"),
  SearchPage(
      name: "Add Item Configuration", route: "/addItemConfigurtionScreen"),
  SearchPage(name: "All Attributes", route: "/allAttributeScreen"),
  SearchPage(name: "Add Attribute", route: "/addAttributeScreen"),
  SearchPage(name: "Item Code Generation", route: "/itemCodeGenerationScreen"),
  SearchPage(
      name: "Add Item Code Generation", route: "/addItemCodeGenerationScreen"),
  SearchPage(name: "Vendor", route: "/vendorScreen"),
  SearchPage(name: "Add Vendor", route: "/addVendorScreen"),
  SearchPage(name: "Formula Procedure", route: "/formulaProcedureScreen"),
  SearchPage(
      name: "Add Formula Procedure", route: "/addformulaProcedureScreen"),
  SearchPage(name: "Add Formula Mapping", route: "/addformulaMapping"),
  SearchPage(name: "Excel Sheet", route: "/excelScreen"),
  SearchPage(name: "Procurement", route: "/procumentScreen"),
  SearchPage(name: "Data Grid", route: "/DataGrid"),
  SearchPage(name: "Barcoding", route: "/barcodingScreen"),
  SearchPage(name: "Inventory Management", route: "/inventoryScreen"),
  SearchPage(name: "Barcode Generation", route: "/barcodeGeneration"),
  SearchPage(name: "Transfer", route: "/transferScreen"),
  SearchPage(
      name: "Transfer Outward Location", route: "/transferOutwardLocation"),
  SearchPage(
      name: "Transfer Inward Location", route: "/transferInwardLocation"),
  SearchPage(name: "Sub Contracting", route: "/subContracting"),
];
