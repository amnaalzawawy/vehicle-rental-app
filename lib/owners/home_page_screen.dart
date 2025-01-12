import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/owners/vehicle_Management_screen.dart';
import '../auth/logout_screen.dart';
import '../models/icons.dart';
import '../providers/car_provider.dart';
import '../widgets/car_card.dart';
import 'booking_management_screen.dart';
import 'owner_profile_page.dart'; // صفحة معلومات المالك


class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return OwnerHomePageState();
  }
}


class OwnerHomePageState extends State<OwnerHomePage>{

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
        title: const Text("الصفحة الرئيسية"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
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
              leading: const Icon(AppIcons.account), // أيقونة حسابي
              title: const Text('حسابي'),
              onTap: () {
                // الانتقال إلى صفحة حسابي
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OwnerProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(AppIcons.bookings), // أيقونة حجوزاتي
              title: const Text('حجوزاتي'),
              onTap: () {
                // الانتقال إلى صفحة إدارة الحجوزات
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookingManagementPage()),
                );
              },
            ), ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل الخروج'),
              onTap:  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogoutScreen()),
                );
              },
            ),

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
                  MaterialPageRoute(builder: (context) => const ManageCarPage()),
                );
              },
              icon: const Icon(AppIcons.vehicle), // أيقونة المركبة
              label: const Text("إضافة مركبة"),
            ),
          ),
          // قائمة المركبات
          Expanded(
            child: Consumer<CarProvider>(
              builder: (context, provider, child) {
                if (provider.cars.isEmpty) {
                  return const Center(child: Text("لا توجد مركبات حالياً"));
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
