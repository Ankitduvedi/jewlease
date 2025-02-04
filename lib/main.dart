import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jewlease/core/routes/go_router.dart';
import 'package:jewlease/data/hive_local_storage/manager/location_storage.dart';
import 'package:jewlease/data/hive_local_storage/model/location_model.dart';
import 'package:jewlease/feature/home/right_side_drawer/controller/drawer_controller.dart';

late double screenHeight;
late double screenWidth;
final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   log('Handling a background message: ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(LocationAdapter()); // Register the adapter
  await LocationStorage.init();
  //final container = ProviderContainer(); // Create a Riverpod container
  //await container.read(locationProvider.future);
  // Prevent duplicate initialization

  // await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    // bool isDarkMode =
    //     MediaQuery.of(context).platformBrightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.dark, // Adjust based on your Scaffold's background color
      ),
    );
    return MaterialApp.router(
      themeMode: ThemeMode.light,
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
    );
  }
}
