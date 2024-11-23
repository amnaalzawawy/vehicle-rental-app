import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

  Future <void> main() async {
    var firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MyApp());
  }
  class MyApp extends StatelessWidget {
  const MyApp({super.key});
    @override
  Widget build(BuildContext context) {
  return MaterialApp(
  title: 'تأجير السيارات',
  theme: ThemeData(
  primarySwatch: Colors.blue,
  ),
  home: CarRentalScreen(), // واجهة البداية
  );
  }
  }

  class CarRentalScreen extends StatefulWidget {
  @override
  _CarRentalScreenState createState() => _CarRentalScreenState();
  }

  class _CarRentalScreenState extends State<CarRentalScreen> {
  String locationText = ''; // نص الموقع

  @override
  Widget build(BuildContext context) {
  return Scaffold(


  );
  }
  }
