import 'package:flutter/material.dart';
import '../models/icons.dart';
import '../auth/logout_screen.dart';
import '../style/styles.dart';
import '../styles/styles.dart';

/// قائمة جانبية للوحة التحكم تحتوي على الروابط الرئيسية
class CustomDrawer extends StatelessWidget {
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
                'Admin Panel',
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
            title: Text('Users', style: AppStyles.drawerText),
            onTap: () {
              Navigator.pushNamed(context, '/users');
            },
          ),
          ListTile(
            leading: Icon(AppIcons.owners, color: Colors.black),
            title: Text('Owners', style: AppStyles.drawerText),
            onTap: () {
              Navigator.pushNamed(context, '/owners');
            },
          ),
          ListTile(
            leading: Icon(AppIcons.bookings, color: Colors.black),
            title: Text('Bookings', style: AppStyles.drawerText),
            onTap: () {
              Navigator.pushNamed(context, '/bookings');
            },
          ),
          ListTile(
            leading: Icon(AppIcons.vehicle, color: Colors.black),
            title: Text('Vechicle', style: AppStyles.drawerText),
            onTap: () {
              Navigator.pushNamed(context, '/vehicle');
            },
          ),
          ListTile(
            leading: Icon(AppIcons.advertisements, color: Colors.black),
            title: Text('Advertisements', style: AppStyles.drawerText),
            onTap: () {
              Navigator.pushNamed(context, '/advertisements');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogoutScreen()),
              );
            },
          ),

        ],
      ),
    );
  }
}
