import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import 'add_user_screen.dart';
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
        title: const Text('إدارة المستخدمين والمالكين'),
      ),
      drawer: CustomDrawer(),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          final users = provider.filteredUsers;

          if (users.isEmpty) {
            return const Center(child: Text('لا يوجد بيانات متوفرة'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImageBase64 != null
                        ? MemoryImage(base64Decode(user.profileImageBase64!))
                        : null,
                    child: user.profileImageBase64 == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text('الدور: ${user.role}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
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
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('تأكيد الحذف'),
                              content: const Text('هل أنت متأكد من حذف هذا المستخدم؟'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('حذف'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await userProvider.deleteUser(user.userId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم حذف المستخدم بنجاح')),
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
      ),
    );
  }
}
