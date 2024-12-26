import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled2/providers/booking_provider.dart';
import 'package:untitled2/providers/car_provider.dart';
import 'auth/login_screen.dart'; // شاشة تسجيل الدخول
import 'Owners/home_page_screen.dart'; // الصفحة الرئيسية للمالك
import 'providers/auth_provider.dart'; // مزود التوثيق
import 'admin/user/user_management_screen.dart'; // شاشة إدارة المستخدمين
import 'user/vehicle_screen.dart'; // شاشة عرض المركبات للمستخدم

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url:"https://riusqflhjwuandiednfy.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJpdXNxZmxoand1YW5kaWVkbmZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUwNTkzNjksImV4cCI6MjA1MDYzNTM2OX0.Ku02SqcaI26RjiG_5ImoO3f69p1lZttGE07lrUMzcVs",
  );
// تهيئة Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(), // ربط الـ Provider
        ),
        ChangeNotifierProvider(create: (context) => CarProvider()),
        ChangeNotifierProvider(create: (context) => BookingProvider()),
      ],
      child: MaterialApp(
        title: 'تطبيق تأجير المركبات',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // جعل الصفحة الرئيسية للمالك هي الصفحة الافتراضية
        home: const HomePage(), // الصفحة الرئيسية للمالك
        // تعريف المسارات للتنقل بين الشاشات
        // routes: {
        //   '/home': (context) => const HomePage(), // الصفحة الرئيسية للمالك
        //   '/login': (context) => LoginScreen(), // شاشة تسجيل الدخول
        //   '/userManagement': (context) => UserManagementScreen(
        //     userId: '',
        //     userData: null,
        //   ), // شاشة إدارة المستخدمين
        //   '/vehicleDisplay': (context) => CarDisplayScreen(), // شاشة عرض المركبات
        // },
      ),
    );
  }
}
