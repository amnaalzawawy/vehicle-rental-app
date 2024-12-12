import 'package:flutter/material.dart';
import '../models/icons.dart';  // تأكد من استيراد النموذج الخاص بالأيقونات

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavigationBarWidget({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(AppIcons.account),  // أيقونة حسابي
          label: 'حسابي',
        ),


        BottomNavigationBarItem(
          icon: Icon(AppIcons.wallet),  // أيقونة المحفظة
          label: 'المحفظة',
        ),
      ],
    );
  }
}
