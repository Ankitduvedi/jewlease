import 'package:go_router/go_router.dart';
import 'package:jewlease/core/routes/navigation_const.dart';
import 'package:jewlease/feature/all_attributes/screen/all_attribute_screen.dart';
import 'package:jewlease/feature/all_attributes/screen/new_attribute_screen.dart';
import 'package:jewlease/feature/auth/screens/login_screen_owner.dart';
import 'package:jewlease/feature/auth/screens/login_screen_staff.dart';
import 'package:jewlease/feature/home/screens/home_screen.dart';
import 'package:jewlease/feature/home/widgets/home_screen_navbar.dart';
import 'package:jewlease/feature/home/screens/welcome_screen.dart';
import 'package:jewlease/feature/item_code_generation/screen/item_code_generation_screen.dart';
import 'package:jewlease/feature/item_code_generation/screen/new_item_code_generation_screen.dart';
import 'package:jewlease/feature/item_configuration/screens/item_configuration_screen.dart';
import 'package:jewlease/feature/item_configuration/screens/new_item_configuration_screen.dart';
import 'package:jewlease/feature/item_specific/screens/add_metal_item_screen.dart';
import 'package:jewlease/feature/item_specific/screens/add_variant_master_screen.dart';
import 'package:jewlease/feature/item_specific/screens/load_data_of_item_master_gold.dart';
import 'package:jewlease/feature/item_specific/screens/master_screen.dart';
import 'package:jewlease/feature/splas_screen/splash_view.dart';

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
                    path: 'addMetalItemScreen',
                    builder: (context, state) {
                      return const AddMetalItemScreen();
                    }),
                GoRoute(
                    path: 'itemMasterGoldScreen',
                    builder: (context, state) {
                      return const ItemMasterGoldScreen(
                        title: 'Metal code',
                        endUrl: 'ItemMasterAndVariants/Metal/Gold/Item/',
                        value: 'Metal code',
                      );
                    }),
              ]),
          GoRoute(
              path: '/addVariantMasterScreen',
              builder: (context, state) {
                return const AddVariantMasterScreen();
              }),
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
        ]),
  ],
);
