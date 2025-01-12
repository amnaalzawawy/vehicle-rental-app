import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/auth/logout_screen.dart';
import 'dart:io';

import 'package:untitled2/providers/current_user_provider.dart';

class OwnerProfilePage extends StatefulWidget {
  const OwnerProfilePage({Key? key}) : super(key: key);

  @override
  State<OwnerProfilePage> createState() => _OwnerProfilePageState();
}

class _OwnerProfilePageState extends State<OwnerProfilePage> {
  final user = FirebaseAuth.instance.currentUser; // المستخدم الحالي
  File? _image; // لحفظ الصورة المؤقتة
  final picker = ImagePicker();
  String? imageUrl;

  final _fristNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();

  // اختيار صورة من المعرض
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  // رفع الصورة إلى Firebase Storage
  Future<void> _uploadImage() async {
    if (_image == null) return;
    // TODO: Migrate to Supabase
    // final storageRef = FirebaseStorage.instance.ref().child('owner_images/${user?.uid}.jpg');

    // await storageRef.putFile(_image!);
    // final url = await storageRef.getDownloadURL();
    // setState(() {
    //   imageUrl = url;
    // });
  }

  // تغيير الرقم السري
  Future<void> _changePassword() async {
    if (_passwordController.text.isEmpty) return;

    try {
      await user?.updatePassword(_passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تغيير الرقم السري بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل تغيير الرقم السري')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    UserProvider().getCurrentUser().then((value) {
    _fristNameController.text = value?.firstName ?? '';
    _lastNameController.text = value?.lastName ?? '';  

    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معلومات المالك'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // صورة المالك
              // GestureDetector(
              //   onTap: _pickImage,
              //   child: CircleAvatar(
              //     radius: 60,
              //     backgroundImage: imageUrl != null
              //         ? NetworkImage(imageUrl!)
              //         : AssetImage('assets/default_avatar.png') as ImageProvider,
              //     child: _image == null ? Icon(Icons.camera_alt) : null,
              //   ),
              // ),
              const SizedBox(height: 20),

              // تفاصيل المالك
              Card(
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.blue),
                      title: const Text('البريد الإلكتروني'),
                      subtitle: Text(
                        user?.email ?? 'لا يوجد بريد مسجل',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      // title: const Text('الاسم الاول'),
                      subtitle: TextField(
                        controller: _fristNameController,
                        decoration: const InputDecoration(
                          labelText: 'الاسم الاول',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                      ),
                    ),
                    ListTile(
                      // title: const Text('الاسم الثاني'),
                      subtitle: TextField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'الاسم الثاني',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('تغيير الرقم السري'),
                      subtitle: TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'كلمة المرور الجديدة',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        obscureText: true,
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),

              // زر تغيير الرقم السري
              ElevatedButton.icon(
                onPressed: _changePassword,
                icon: const Icon(Icons.save),
                label: const Text('تغيير الرقم السري'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 12,),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogoutScreen()),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white,),
                label: Text('تسجيل الخروج', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
