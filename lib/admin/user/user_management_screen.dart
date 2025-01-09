import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/widgets/custom_drawer.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import 'add_user_screen.dart';
import 'package:untitled2/models/user.dart';
import '../../widgets/custom_drawer.dart';
import 'edit_user_screen.dart';

class ManageUsersOwnersScreen extends StatefulWidget {
  @override
  _ManageUsersOwnersScreenState createState() => _ManageUsersOwnersScreenState();
}

class _ManageUsersOwnersScreenState extends State<ManageUsersOwnersScreen> {
  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).fetchUsers();
    } catch (e) {
      // عرض رسالة خطأ في حال فشل تحميل البيانات
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تحميل البيانات: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        title: Text('إدارة المستخدمين والمالكين'),
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          final users = provider.filteredUsers; // الحصول على المستخدمين المصفاة

          if (users.isEmpty) {
            return Center(child: Text('لا يوجد بيانات متوفرة'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا يوجد مستخدمون'));
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = UserModel.fromMap(users[index] as Map<String, dynamic>);
              return ListTile(
                title: Text("${user.firstName} ${user.lastName}"),
                subtitle: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserScreen(userId: user.email, userData: user),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.email)
                            .delete();
                      },
                    ),
                  ],
              final user = users[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImageBase64 != null
                        ? MemoryImage(base64Decode(user.profileImageBase64!))
                        : null,
                    child: user.profileImageBase64 == null
                        ? Icon(Icons.person)
                        : null,
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text('الدور: ${user.role}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserScreen(user: user),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('تأكيد الحذف'),
                              content: Text('هل أنت متأكد من حذف هذا المستخدم؟'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text('حذف'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await userProvider.deleteUser(user.userId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تم حذف المستخدم بنجاح')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('فشل حذف المستخدم: ${e.toString()}')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        child: Icon(Icons.add), // يمكنك إعادة const هنا
      ),
    );
  }
}
