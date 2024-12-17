/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/auth/login_screen.dart';  // شاشة تسجيل الدخول
import 'providers/auth_provider.dart';  // مزود التوثيق
import 'admin/user/user_management_screen.dart'; // شاشة إدارة المستخدمين
import 'user/vehicle_screen.dart';  // شاشة المستخدم (عرض المركبات)

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
         ChangeNotifierProvider(
        create: (context) => AuthProvider(), // ربط الـ Provider
        child: ChangeNotifierProvider(create: (_) => AuthProvider()), // إضافة AuthProvider كمزود
         ),],
      child: MaterialApp(
        title: 'تطبيق تأجير المركبات',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // التحقق من حالة تسجيل الدخول هنا مباشرة
        home: Builder(
          builder: (context) {
            final authProvider = Provider.of<AuthProvider>(context);

            // إذا كان المستخدم مسجل الدخول
            if (authProvider.isAuthenticated) {
              // تحديد نوع المستخدم بناءً على الدور
              if (authProvider.role == 'admin') {
                return UserManagementScreen(userId: authProvider.currentUser?.userId ?? '', userData: null,); // تمرير userId
              } else if (authProvider.role == 'user') {
                return CarDisplayScreen(); // واجهة المستخدم العادي
              } else {
                // في حالة وجود دور غير معروف
                return Center(
                  child: Text('دور المستخدم غير معروف!'),
                );
              }
            } else {
              // إذا لم يكن المستخدم مسجل الدخول
              return LoginScreen(); // توجيه المستخدم لشاشة تسجيل الدخول
            }
          },
        ),
        // تعريف المسارات للتنقل بين الشاشات
        routes: {
          '/login': (context) => LoginScreen(), // شاشة تسجيل الدخول
          '/userManagement': (context) => UserManagementScreen(userId: '', userData: null,), // شاشة إدارة المستخدمين


        },
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Owners/home_page_screen.dart';
import 'providers/auth_provider.dart'; // مزوّد التوثيق
import 'providers/car_provider.dart'; // إضافة CarProvider
import 'owner/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تهيئة Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(), // مزوّد التوثيق
        ),
        ChangeNotifierProvider(
          create: (context) => CarProvider(), // إضافة CarProvider هنا
        ),
      ],
      child: MaterialApp(
        title: 'تطبيق تأجير المركبات',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(), // الصفحة الرئيسية
      ),
    );
  }
}
