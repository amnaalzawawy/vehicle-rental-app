import 'package:flutter/material.dart';
import '../models/icons.dart';
import '../auth/logout_screen.dart';
import '../style/styles.dart';


/// قائمة جانبية للوحة التحكم تحتوي على الروابط الرئيسية
class CustomDrawer2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFF78B00),  // اللون الأساسي للـDrawer
            ),
            child: Center(
              child: Text(
                'مرحبا بك',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          ListTile(
            leading: Icon(AppIcons.users, color: Colors.black),
            title: Text('حسابي', style: AppStyles.drawerText),
            onTap: () {
              Navigator.pushNamed(context, '/myAccount');
            },
          ),
          ListTile(
            leading: Icon(AppIcons.owners, color: Colors.black),
            title: Text('المركبات', style: AppStyles.drawerText),
            onTap: () {
              Navigator.pushNamed(context, '/vehicalScreen');
            },
          ),
          ListTile(
            leading: Icon(AppIcons.bookings, color: Colors.black),
            title: Text('حجوزاتي', style: AppStyles.drawerText),
            onTap: () {
              Navigator.pushNamed(context, '/myBooking');
            },
          ),




        ],
      ),
    );
  }
}
