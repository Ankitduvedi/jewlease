import 'package:go_router/go_router.dart';
import 'package:jewlease/core/routes/navigation_const.dart';
import 'package:jewlease/feature/auth/screens/login_screen_owner.dart';
import 'package:jewlease/feature/auth/screens/login_screen_staff.dart';
import 'package:jewlease/feature/home/screens/home_screen.dart';
import 'package:jewlease/feature/home/widgets/home_screen_navbar.dart';
import 'package:jewlease/feature/home/screens/welcome_screen.dart';
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

    // GoRoute(
    //   path: '/updateAppScreen',
    //   builder: (context, state) => const UpdateAppScreen(),
    // ),
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
    //   path: '/setupHotelScreen',
    //   builder: (context, state) => const SetupHotelScreen(),
    // ),

    // GoRoute(
    //   path: '/appointStaffScreen',
    //   builder: (context, state) => const AppointStaffScreen(),
    // ),
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
              path: '/staff',
              builder: (context, state) {
                return const HomeScreen();
              }),

          // GoRoute(
          //   path: '/hotelDetailsScreen/:id',
          //   builder: (context, state) =>
          //       HotelDetailsScreen(restaurantId: state.pathParameters['id']!),
          // ),
          // GoRoute(
          //   path: '/createMenuScreen',
          //   builder: (context, state) {
          //     return const CreateMenuScreen();
          //   },
          //),

          // GoRoute(
          //   path: '/account',
          //   builder: (context, state) => const ProfileScreen(),
          // )
        ]),
  ],
);
