import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled2/admin/vehicle/vechicle_management_screen.dart';
import 'package:untitled2/providers/booking_provider.dart';
import 'package:untitled2/providers/car_provider.dart';
import 'package:untitled2/providers/user_provider.dart';
import 'package:untitled2/screens/login_screen.dart';
import 'package:untitled2/user/my_account_screen.dart';
import 'package:untitled2/providers/current_user_provider.dart' as current_user_provider;
import 'package:untitled2/user/my_booking.dart';
import 'package:untitled2/user/vehicle_screen.dart';
import 'admin/user/user_search.dart';
import 'auth/login_screen.dart';
import 'home_router.dart';
import 'owners/booking_management_screen.dart';
import 'owners/owner_profile_page.dart';
import 'owners/vehicle_management_screen.dart';

String SUPABASE_URL = "https://riusqflhjwuandiednfy.supabase.co";
String SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJpdXNxZmxoand1YW5kaWVkbmZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUwNTkzNjksImV4cCI6MjA1MDYzNTM2OX0.Ku02SqcaI26RjiG_5ImoO3f69p1lZttGE07lrUMzcVs";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(create: (_) => current_user_provider.UserProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'تطبيق تأجير المركبات',
        theme: ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/myAccount': (context) => const AccountScreen(),
          '/myBooking' :(context) => const MyBookingsScreen(),
          '/vehicalScreen' :(context) => const CarDisplayScreen(),
          '/owner/manage' :(context) => const ManageCarPage(),
          '/owner/bookings' :(context) => const BookingManagementPage(),
          '/owner/account' :(context) => const OwnerProfilePage(),
          '/users' :(context) => const UserSearchScreen(),
          '/' :(context) => const HomeRouter(), // Home replacement
          '/CarScreen' :(context) => const CarScreen(),
        },
      ),
    );
  }
}
