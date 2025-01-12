import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/models/car.dart';
import 'package:untitled2/models/user.dart';
import 'package:untitled2/providers/current_user_provider.dart';

import 'vechicle_add_screen.dart';

class OwnerCarCard extends StatefulWidget {

  final CarModel car;
  const OwnerCarCard({required this.car, super.key});

  @override
  State<StatefulWidget> createState() {
    return OwnerCarCardState();
  }
}


class OwnerCarCardState extends State<OwnerCarCard>{
  UserModel? user;


  void getClientInfo(String userid) async {
    var owner = await Provider.of<UserProvider>(context, listen: false).getUser(userid);
    setState(() {
      user = owner;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getClientInfo(widget.car.owner);
    });
  }


  @override
  Widget build(BuildContext context) {
    var car = widget.car;
    return ListTile(
      title: Text(car.name), // عرض اسم المركبة
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('فئة: ${car.category}'),
          if(user != null)Text('مالك: ${user?.firstName} ${user?.lastName}'),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddCarDialog(carToEdit: car),
          );
        },
      ),
    );
  }

}