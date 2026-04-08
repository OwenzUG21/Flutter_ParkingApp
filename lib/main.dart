// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project8/screens/bookingscreen.dart';
import 'package:project8/screens/dashboard.dart';
import 'package:project8/screens/reservationscreen.dart';
import 'package:project8/screens/parking_spots.dart';
import 'package:project8/screens/mobile_money_payment.dart';
import 'package:project8/screens/chat_screen.dart';
import 'package:project8/screens/auth_wrapper.dart';
import 'package:project8/screens/edit_profile_screen.dart';
import 'package:project8/screens/profile_screen.dart';
import 'package:project8/screens/notifications_screen.dart';
import 'package:project8/screens/onesignal_test_screen.dart';
import 'package:project8/services/theme_service.dart';
import 'package:project8/themes/app_theme.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';
import 'services/database_manager.dart';
import 'services/notification_service.dart';
import 'services/onesignal_service.dart';
import 'services/onesignal_diagnostic.dart';

// Global navigator key for navigation from anywhere
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize databases (Isar + Hive + Drift)
  await DatabaseManager().initialize();

  // Initialize notification service
  await NotificationService().initialize();

  // Initialize OneSignal
  await OneSignalService().initialize();

  // Run diagnostics (remove in production)
  await Future.delayed(const Duration(seconds: 3));
  await OneSignalDiagnostic.runDiagnostics();

  // Initialize theme service
  await ThemeService().initialize();

  runApp(const ParkFlexApp());
}

class ParkFlexApp extends StatelessWidget {
  const ParkFlexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "ParkFlexApp",
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeService().themeMode,
          initialRoute: '/splash',
          navigatorKey: _navigatorKey,
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/auth': (context) => const AuthWrapper(),
            '/signup': (context) => const SignupScreen(),
            '/parking-spots': (context) => const ParkingSpotsScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/edit-profile': (context) => const EditProfileScreen(),
            '/notifications': (context) => const NotificationsScreen(),
            '/onesignal-test': (context) => const OneSignalTestScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/dashboard') {
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (context) =>
                    DashboardScreen(initialTab: args?['initialTab'] as int?),
              );
            }
            if (settings.name == '/booking') {
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (context) => BookingScreen(
                  parkingName: args?['parkingName'] ?? 'Acacia Mall Parking',
                  parkingLocation:
                      args?['parkingLocation'] ?? 'Kololo, Kampala',
                  spacesLeft: args?['spacesLeft'] ?? 45,
                  pricePerHour: args?['pricePerHour'] ?? 5000,
                  slotNumber: args?['slotNumber'] as int?,
                ),
              );
            }
            if (settings.name == '/reservation') {
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (context) => ReservationDetailsScreen(
                  parkingName: args?['parkingName'] ?? 'Acacia Mall Parking',
                  parkingLocation:
                      args?['parkingLocation'] ?? 'Kololo, Kampala',
                  date: args?['date'] ?? DateTime.now(),
                  duration: args?['duration'] ?? '2 Hr',
                  hours: args?['hours'] ?? 2,
                  parkingRate: args?['parkingRate'] ?? 10000,
                  serviceFee: args?['serviceFee'] ?? 1500,
                  totalCost: args?['totalCost'] ?? 11500,
                  slotNumber: args?['slotNumber'] as int?,
                  startTime: args?['startTime'] as TimeOfDay?,
                  vehiclePlate: args?['vehiclePlate'] as String?,
                  imagePath: args?['imagePath'] as String?,
                  reservationId: args?['reservationId'] as String?,
                  parkingRecordId: args?['parkingRecordId'] as int?,
                ),
              );
            }
            if (settings.name == '/mobile-money-payment') {
              final args = settings.arguments as Map<String, dynamic>?;
              return MaterialPageRoute(
                builder: (context) => MobileMoneyPaymentScreen(
                  totalAmount: args?['totalAmount'] ?? 11500,
                  parkingName: args?['parkingName'] ?? 'Acacia Mall Parking',
                  parkingLocation:
                      args?['parkingLocation'] ?? 'Kololo, Kampala',
                  reservationId: args?['reservationId'] as String?,
                  parkingRecordId: args?['parkingRecordId'] as int?,
                  vehiclePlate: args?['vehiclePlate'] as String?,
                  slotNumber: args?['slotNumber'] as String?,
                  duration: args?['duration'] as String?,
                  hours: args?['hours'] as int?,
                ),
              );
            }
            if (settings.name == '/chat') {
              return MaterialPageRoute(
                builder: (context) => const ChatScreen(),
              );
            }
            return null;
          },
        );
      },
    );
  }
}

class AppColor {
  static const Color background = Color(0xFF121212);
}
