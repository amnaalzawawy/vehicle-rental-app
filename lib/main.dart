/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/providers/booking_provider.dart';
import 'package:untitled2/providers/car_provider.dart';
import 'package:untitled2/providers/user_provider.dart';
import 'package:untitled2/screens/login_screen.dart'; // شاشة تسجيل الدخول
import 'package:untitled2/user/my_account_screen.dart'; // شاشة حسابي
import 'package:untitled2/providers/auth_provider.dart';

import 'auth/login_screen.dart'; // مزود التوثيق

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تهيئة Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        title: 'تطبيق تأجير المركبات',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(), // شاشة البداية كواجهة ابتدائية
        routes: {
          '/login': (context) => SignUpScreen(),
          '/myAccount': (context) => AccountScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserSession();
  }

  // التحقق من حالة الجلسة
  Future<void> _checkUserSession() async {
    await Future.delayed(Duration(seconds: 3)); // عرض شاشة البداية لمدة 3 ثوانٍ

    // التحقق من المستخدم المسجل الدخول
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // إذا كان هناك مستخدم مسجل الدخول، التوجه إلى شاشة الحساب
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AccountScreen()),
      );
    } else {
      // إذا لم يكن هناك مستخدم مسجل الدخول، التوجه إلى شاشة تسجيل الدخول
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF78B00),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.car_rental, // أيقونة التطبيق
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'تطبيق تأجير المركبات',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled2/owners/owner_profile_page.dart';
import 'package:untitled2/providers/booking_provider.dart';
import 'package:untitled2/providers/car_provider.dart';
import 'package:untitled2/providers/user_provider.dart';
import 'package:untitled2/screens/login_screen.dart';
// import 'package:untitled2/screens/login_screen.dart'; // شاشة تسجيل الدخول
import 'package:untitled2/user/my_account_screen.dart'; // شاشة حسابي
import 'package:untitled2/providers/auth_provider.dart';
import 'package:untitled2/user/my_booking.dart';
import 'package:untitled2/user/vehicle_screen.dart';

import 'admin/vehicle/vechicle_management_screen.dart';
import 'admin/vehicle/vechicle_management_screen.dart';
import 'auth/login_screen.dart';
import 'owners/vehicle_management_screen.dart'; // شاشة عرض المركبات

String SUPABASE_URL = "https://riusqflhjwuandiednfy.supabase.co";
String SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJpdXNxZmxoand1YW5kaWVkbmZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUwNTkzNjksImV4cCI6MjA1MDYzNTM2OX0.Ku02SqcaI26RjiG_5ImoO3f69p1lZttGE07lrUMzcVs";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تهيئة Firebase
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        title: 'تطبيق تأجير المركبات',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: CarDisplayScreen(), // شاشة عرض المركبات مباشرة كواجهة رئيسية
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/myAccount': (context) => AccountScreen(),
          '/myBooking' :(context) => MyBookingsScreen(),
          '/vehicalScreen' :(context) => const CarDisplayScreen(),
          '/owner/manage' :(context) => const ManageCarPage(),
          '/owner/account' :(context) => const OwnerProfilePage(),
          '/' :(context) => const CarDisplayScreen(), // Home replacement
          '/CarScreen' :(context) => CarScreen(),
        },
      ),
    );
  }
}
