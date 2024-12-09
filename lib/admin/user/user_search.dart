
// شاشة البحث عن مستخدم
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserSearchScreen extends StatelessWidget {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('بحث عن مستخدم'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'ادخل الاسم أو الرقم', border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('name', isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('لا يوجد نتائج'));
                }
                final users = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    return ListTile(
                      title: Text(user['name']),
                      subtitle: Text(user['phone']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
