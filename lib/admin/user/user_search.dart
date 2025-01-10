// شاشة البحث عن مستخدم
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import 'edit_user_screen.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final _searchController = TextEditingController();
  List<UserModel> users = [];
  bool loading = false;

  void searchUsers() {
    setState(() {
      loading = true;
    });
    Provider.of<UserProvider>(context, listen: false)
        .search(_searchController.text)
        .then((value) {
      setState(() {
        users = value ?? [];
        loading = false;
      });
    }).catchError((error) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء البحث: $error')),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بحث عن مستخدم'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: searchUsers,
                  icon: const Icon(Icons.search),
                  label: const Text('بحث'),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'ادخل الاسم أو الرقم',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : users.isEmpty
                ? const Center(child: Text('لا يوجد نتائج'))
                : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return Card(
                  child: ListTile(
                    title: Text("${user.firstName} ${user.lastName}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(user.email),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("هل تريد تأكيد الحذف؟"),
                                    content: Text(
                                      "${user.firstName} ${user.lastName}\n${user.email}",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("إلغاء"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Provider.of<UserProvider>(
                                              context,
                                              listen: false)
                                              .remove(user.email)
                                              .then((_) {
                                            searchUsers();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text("تأكيد الحذف"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Icon(Icons.delete_rounded),
                            ),
                            const SizedBox(width: 12),
                            FilledButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditUserScreen(
                                      user: user,
                                    ),
                                  ),
                                );
                                searchUsers();
                              },
                              child: const Icon(Icons.edit_sharp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
