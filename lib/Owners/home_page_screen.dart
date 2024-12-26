import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Owners/vehicle%20_Management_screen.dart';
import '../models/icons.dart';
import '../providers/car_provider.dart';
import '../widgets/car_card.dart';
//import '../models/app_icons.dart'; // استدعاء الأيقونات من ملف app_icons.dart
import 'booking _Management_screen.dart';
import 'owner_profile_page.dart'; // صفحة معلومات المالك
//import 'booking_management_page.dart'; // صفحة إدارة الحجوزات
//import 'financial_transactions_page.dart'; // صفحة المعاملات المالية

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}


class HomePageState extends State<HomePage>{

  @override
  void initState() {
    super.initState();

    final carProvider = Provider.of<CarProvider>(this.context, listen: false);
    // جلب البيانات بعد بناء الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      carProvider.fetchCars();
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("الصفحة الرئيسية"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'مرحبا بك',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(AppIcons.account), // أيقونة حسابي
              title: Text('حسابي'),
              onTap: () {
                // الانتقال إلى صفحة حسابي
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OwnerProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(AppIcons.bookings), // أيقونة حجوزاتي
              title: Text('حجوزاتي'),
              onTap: () {
                // الانتقال إلى صفحة إدارة الحجوزات
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingManagementPage()),
                );
              },
            ),
            /*ListTile(
             // leading: Icon(AppIcons.wallet), // أيقونة المعاملات المالية
             // title: Text('المعاملات المالية'),
              //onTap: () {
                // الانتقال إلى صفحة المعاملات المالية
               // Navigator.push(
                 // context,
                  MaterialPageRoute(builder: (context) => FinancialTransactionsPage()),
                );
              },
            ),*/
          ],
        ),
      ),
      body: Column(
        children: [
          // زر إضافة مركبة
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageCarPage()),
                );
              },
              icon: Icon(AppIcons.vehicle), // أيقونة المركبة
              label: Text("إضافة مركبة"),
            ),
          ),
          // قائمة المركبات
          Expanded(
            child: Consumer<CarProvider>(
              builder: (context, provider, child) {
                if (provider.cars.isEmpty) {
                  return Center(child: Text("لا توجد مركبات حالياً"));
                }
                return ListView.builder(
                  itemCount: provider.cars.length,
                  itemBuilder: (context, index) {
                    final car = provider.cars[index];
                    return CarCard(
                      car: car,
                      onEdit: () {
                        // التنقل لصفحة الإدارة مع تمرير المركبة للتعديل
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageCarPage(car: car),
                          ),
                        );
                      },
                      onDelete: () {
                        provider.deleteCar(car.id);
                      },
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
