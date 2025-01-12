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


        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'حجوزاتي'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'حسابي'),
      ],
    );
  }
}
