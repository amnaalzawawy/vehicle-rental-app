
// شاشة البحث عن مستخدم
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/user.dart';
import 'package:untitled2/providers/user_provider.dart';

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


  void searchUsers(){
    setState(() {
      loading = true;
    });
    Provider.of<UserProvider>(context, listen: false).search(_searchController.text).then((value) {

      setState(() {
        if(value != null) {
          users = value;
        }
        loading = false;
      });
    },);
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
                ElevatedButton.icon(onPressed: (){
                  searchUsers();
                }, label: const Icon(Icons.search), ),
                Container(width: 8,),
                Flexible(child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(labelText: 'ادخل الاسم أو الرقم', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24)))),
                ))
              ],
            ),
          ),
          Expanded(
            child: loading?
                  const Center(child: CircularProgressIndicator()):

                users.isEmpty?
                  const Center(child: Text('لا يوجد نتائج')):

                ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    return Card(
                      child: ListTile(
                        title: Text("${user.firstName} ${user.lastName}"),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [

                          Text(user.email),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(onPressed: (){
                                  Widget okButton = TextButton(
                                    child: const Text("تأكيد الحذف"),
                                    onPressed: () {
                                      Provider.of<UserProvider>(context, listen: false).remove(user.email).then((value) {
                                        searchUsers();
                                        Navigator.pop(context);
                                      },);
                                    },
                                  );
                                  Widget cancelButton = FilledButton(
                                    child: const Text("الغاء"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  );

                                  // set up the AlertDialog
                                  AlertDialog alert = AlertDialog(
                                    title: const Text("هل تريد تأكيد الحذف"),
                                    content: Text("${user.firstName} ${user.lastName} \n${user.email}"),
                                    actions: [
                                      okButton,
                                      cancelButton
                                    ],
                                  );

                                  showDialog(context: context, builder: (context) => alert,);
                                }, child: const Icon(Icons.delete_rounded)),
                                const SizedBox(width: 12,),

                                FilledButton(onPressed: () async {
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => EditUserScreen(userId: user.email, userData: user,),));
                                }, child: const Icon(Icons.edit_sharp))
                              ],
                            )

                          ],
                        )

                      ),
                    );
                  },
                )

            ),

        ],
      ),
    );
  }
}
