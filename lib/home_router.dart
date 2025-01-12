


import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/admin/vehicle/vechicle_management_screen.dart';
import 'package:untitled2/providers/current_user_provider.dart';
import 'package:untitled2/user/vehicle_screen.dart';

import 'owners/home_page_screen.dart';

class HomeRouter extends StatefulWidget{
  const HomeRouter({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeRouterState();
  }

}


class HomeRouterState extends State<HomeRouter>{
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, value, child) {
      if(value.currentUser?.role == "admin") {
        return const CarScreen();
      }

      if(value.currentUser?.role == "owner") {
        return const OwnerHomePage();
      }


      return const CarDisplayScreen();
    },);
  }

}