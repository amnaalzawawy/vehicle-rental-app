import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/car_provider.dart'; // استدعاء CarProvider
import 'screens/car_details_screen.dart';
import 'screens/home_screen.dart'; // استدعاء الشاشة الرئيسية
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
 {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GO Car',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  VehicleDetailScreen(vehicleId: '',), // هنا يتم استدعاء الشاشة الرئيسية
    );
  }
}
