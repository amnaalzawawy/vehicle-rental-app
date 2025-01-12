import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/providers/current_user_provider.dart';
import '../models/icons.dart';
import '../style/styles.dart';


class CustomDrawer2 extends StatefulWidget {
  const CustomDrawer2({super.key});

  @override
  State<CustomDrawer2> createState() => _CustomDrawer2State();
}

class _CustomDrawer2State extends State<CustomDrawer2> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFF78B00),  // اللون الأساسي للـDrawer
            ),
            child: Center(
              child: Text(
                'لوحة التحكم للأدمن ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(AppIcons.account, color: Colors.black),
            title: const Text('حسابي', style: AppStyles.drawerText),
            onTap: () {
              Navigator.pushNamed(context, '/myAccount');
            },
          ),
          ListTile(
            leading: const Icon(AppIcons.vehicle, color: Colors.black),
            title: const Text('المركبات', style: AppStyles.drawerText),
            onTap: () {
              Navigator.pushNamed(context, '/CarScreen');
            },
          ),


          Consumer<UserProvider>(builder: (context, value, child) {
            if(value.currentUser?.role == "admin"){
              return ListTile(
                leading: const Icon(AppIcons.users, color: Colors.black),
                title: const Text('المستخدمين', style: AppStyles.drawerText),
                onTap: () {
                  Navigator.pushNamed(context, '/users');
                },
              );
            }
            return Container();
          }
          ),
          ListTile(
            leading: const Icon(AppIcons.bookings, color: Colors.black),
            title: const Text('الحجوزات', style: AppStyles.drawerText),
            onTap: () {
              Navigator.pushNamed(context, '/myBooking');
            },
          ),




        ],
      ),
    );
  }
}
