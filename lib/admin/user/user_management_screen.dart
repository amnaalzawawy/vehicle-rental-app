import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';
import 'edit_user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// شاشة إدارة المستخدمين
class UserManagementScreen extends StatelessWidget {
  final String userId;
  final dynamic userData;

UserManagementScreen({required this.userId, required this.userData});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة المستخدمين'),
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('لا يوجد مستخدمون'));
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['name']),
                subtitle: Text(user['phone']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserScreen(userId: user.id, userData: user),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.id)
                            .delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_user');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
