import 'package:go_router/go_router.dart';
import 'package:jewlease/core/routes/navigation_const.dart';
import 'package:jewlease/feature/all_attributes/screen/all_attribute_screen.dart';
import 'package:jewlease/feature/all_attributes/screen/new_attribute_screen.dart';
import 'package:jewlease/feature/auth/screens/login_screen_owner.dart';
import 'package:jewlease/feature/auth/screens/login_screen_staff.dart';
import 'package:jewlease/feature/barcoding/screens/barCodeGeneration.dart';
import 'package:jewlease/feature/formula/screens/addFormulaProcedure.dart';
import 'package:jewlease/feature/formula/screens/excelScreen.dart';
import 'package:jewlease/feature/formula/screens/formula_procedure.dart';
import 'package:jewlease/feature/home/screens/home_screen.dart';
import 'package:jewlease/feature/home/screens/welcome_screen.dart';
import 'package:jewlease/feature/home/widgets/home_screen_navbar.dart';
import 'package:jewlease/feature/item_code_generation/screen/item_code_generation_screen.dart';
import 'package:jewlease/feature/item_code_generation/screen/new_item_code_generation_screen.dart';
import 'package:jewlease/feature/item_configuration/screens/item_configuration_screen.dart';
import 'package:jewlease/feature/item_configuration/screens/new_item_configuration_screen.dart';
import 'package:jewlease/feature/item_specific/screens/add_certificate_item_screen.dart';
import 'package:jewlease/feature/item_specific/screens/add_consumables_item_screen.dart';
import 'package:jewlease/feature/item_specific/screens/add_metal_item_screen.dart';
import 'package:jewlease/feature/item_specific/screens/add_metal_variant_screen.dart';
import 'package:jewlease/feature/item_specific/screens/add_packing_material_item_screen.dart';
import 'package:jewlease/feature/item_specific/screens/add_set_item_screen.dart';
import 'package:jewlease/feature/item_specific/screens/add_stone_item_screen.dart';
import 'package:jewlease/feature/item_specific/screens/add_style_item_screen.dart';
import 'package:jewlease/feature/item_specific/screens/load_data_of_item_master_metal.dart';
import 'package:jewlease/feature/item_specific/screens/load_data_of_item_master_stone.dart';
import 'package:jewlease/feature/item_specific/screens/load_data_of_variant_master_gold.dart';
import 'package:jewlease/feature/item_specific/screens/master_screen.dart';
import 'package:jewlease/feature/vendor/screens/Bom&Operation.dart';
import 'package:jewlease/feature/vendor/screens/new_vendor_screen.dart';
import 'package:jewlease/feature/vendor/screens/vendor_screen.dart';

import '../../feature/barcoding/screens/barcoding_screen.dart';
import '../../feature/inventoryManagement/screens/inventoryScreen.dart';
import '../../feature/item_specific/screens/add_style_variant.dart';
import '../../feature/procument/screens/procumentScreen.dart';
import '../../feature/splash_screen/splash_view.dart';

final goRouter = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: NavigationService.rootNavigatorKey,
  initialLocation: '/splashScreen',
  routes: <RouteBase>[
    GoRoute(
      path: '/splashScreen',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: '/welcomeScreen',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/loginScreen',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/loginScreenStaff',
      builder: (context, state) => const LoginScreenStaff(),
    ),

    // GoRoute(
    //     path: '/onBoardingScreens',
    //     builder: (context, state) => const OnBoardingScreen(),
    //     routes: [
    //       GoRoute(
    //         path: 'introductionScreen1',
    //         builder: (context, state) => const IntroPage1(),
    //       ),
    //       GoRoute(
    //         path: 'introductionScreen2',
    //         builder: (context, state) => const IntroPage2(),
    //       ),
    //       GoRoute(
    //         path: 'introductionScreen3',
    //         builder: (context, state) => const IntroPage3(),
    //       ),
    //       GoRoute(
    //         path: 'introductionScreen4',
    //         builder: (context, state) => const IntroPage4(),
    //       ),
    //       GoRoute(
    //         path: 'introductionScreen5',
    //         builder: (context, state) => const IntroPage5(),
    //       ),
    //     ]),
    ShellRoute(
        navigatorKey: NavigationService.shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(
              childScreen: child,
            ),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
              path: '/masterScreen',
              builder: (context, state) {
                return const MasterScreen();
              },
              routes: [
                GoRoute(
                    path: 'addStyleItemScreen',
                    builder: (context, state) {
                      return const AddStyleItemScreen();
                    }),
                GoRoute(
                    path: 'addStyleVariantScreen',
                    builder: (context, state) {
                      return const AddStyleVariantScreen();
                    }),
                GoRoute(
                    path: 'addMetalItemScreen',
                    builder: (context, state) {
                      return const AddMetalItemScreen();
                    }),
                GoRoute(
                    path: 'addStoneItemScreen',
                    builder: (context, state) {
                      return const AddStoneItemScreen();
                    }),
                GoRoute(
                    path: 'addConsumablesItemScreen',
                    builder: (context, state) {
                      return const AddConsumablesItemScreen();
                    }),
                GoRoute(
                    path: 'addSetItemScreen',
                    builder: (context, state) {
                      return const AddSetItemScreen();
                    }),
                GoRoute(
                    path: 'addCertificateItemScreen',
                    builder: (context, state) {
                      return const AddCertificateItemScreen();
                    }),
                GoRoute(
                    path: 'addPackingMaterialItemScreen',
                    builder: (context, state) {
                      return const AddPackingMaterialItemScreen();
                    }),
                GoRoute(
                    path: 'addMetalVariantScreen',
                    builder: (context, state) {
                      return const AddMetalVariantScreen();
                    }),
                GoRoute(
                    path: 'itemMasterGoldScreen',
                    builder: (context, state) {
                      return const ItemMasterGoldScreen(
                        value: 'Metal code',
                      );
                    }),
                GoRoute(
                    path: 'itemMasterStoneScreen',
                    builder: (context, state) {
                      return const ItemMasterStoneScreen(
                        value: 'Stone code',
                      );
                    }),
                GoRoute(
                    path: 'variantMasterGoldScreen',
                    builder: (context, state) {
                      return const VariantMasterGoldScreen(
                        title: 'Variant Master (Item Group- Gold)',
                        endUrl: 'ItemMasterAndVariants/Metal/Gold/Variant/',
                        value: 'Metal code',
                      );
                    }),
              ]),
          GoRoute(
              path: '/itemConfigurationScreen',
              builder: (context, state) {
                return const ItemConfigurationScreen();
              }),
          GoRoute(
              path: '/addItemConfigurtionScreen',
              builder: (context, state) {
                return const AddItemConfigurtionScreen();
              }),
          GoRoute(
              path: '/allAttributeScreen',
              builder: (context, state) {
                return const AllAttributeScreen();
              }),
          GoRoute(
              path: '/addAttributeScreen',
              builder: (context, state) {
                return const AddAttributeScreen();
              }),
          GoRoute(
              path: '/itemCodeGenerationScreen',
              builder: (context, state) {
                return const ItemCodeGenerationScreen();
              }),
          GoRoute(
              path: '/addItemCodeGenerationScreen',
              builder: (context, state) {
                return const AddItemCodeGenerationScreen();
              }),
          GoRoute(
              path: '/vendorScreen',
              builder: (context, state) {
                return const VendorScreen();
              }),
          GoRoute(
              path: '/addVendorScreen',
              builder: (context, state) {
                return const AddVendor();
              }),
          GoRoute(
              path: '/formulaProcedureScreen',
              builder: (context, state) {
                return FormulaProcdedureScreen();
              }),
          GoRoute(
              path: '/addformulaProcedureScreen',
              builder: (context, state) {
                print("going through route");
                print("stat is ${state.extra}");
                final extraData = state.extra as Map<String, dynamic>;
                // as Map<String, dynamic>; // Cast to the expected type
                print("print extra data $extraData");
                return AddFormulaProcedure(
                  ProcedureType: extraData != null
                      ? extraData['Procedure Type'] ?? ''
                      : '',
                  FormulaProcedureName: extraData != null
                      ? extraData['Formula Procedure Name'] ?? ''
                      : '',
                );
              }),
          GoRoute(
              path: '/excelScreen',
              builder: (context, state) {
                return ExcelSheet();
              }),
          GoRoute(
              path: '/procumentScreen',
              builder: (context, state) {
                return procumentScreen();
              }),
          GoRoute(
              path: '/DataGrid',
              builder: (context, state) {
                return MyDataGrid();
              }),
          GoRoute(
              path: '/barcodingScreen',
              builder: (context, state) {
                return const BarcodingScreen();
              }),
          GoRoute(
              path: '/inventoryScreen',
              builder: (context, state) {
                return const InventoryManagementScreen();
              }),
          GoRoute(
              path: '/barcodeGeneration',
              builder: (context, state) {
                return const BarCodeGeneration();
              }),
        ]),
  ],
);
