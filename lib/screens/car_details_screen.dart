/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/car.dart';
import '../providers/car_provider.dart';

class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;

  VehicleDetailScreen({required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    // البحث عن المركبة باستخدام الـ vehicleId
    final vehicle = vehicleProvider.vehicles.firstWhere(
          (v) => v.carId == vehicleId,
      orElse: () => Vehicle(
        carId: '',
        carName: '',
        availability: '',
        dailyRate: 0.0,
        fuelType: '',
        ownerId: '',
        seatingCapacity: 0,
        vehicleClass: '',
        imageUrl: '',
      ),
    );

    // إذا لم يتم العثور على المركبة
    if (vehicle.carId == '') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل المركبة'),
        ),
        body: const Center(
          child: Text(
            'المركبة غير موجودة',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle.carName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // صورة المركبة
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(vehicle.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // تفاصيل المركبة
            Text(
              vehicle.carName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'فئة المركبة: ${vehicle.vehicleClass}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'نوع الوقود: ${vehicle.fuelType}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'سعة المقاعد: ${vehicle.seatingCapacity}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'السعر لكل يوم: \$${vehicle.dailyRate.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'التوفر: ${vehicle.availability == "available" ? "متوفرة" : "غير متوفرة"}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // زر الحجز
            ElevatedButton(
              onPressed: vehicle.availability == 'available' ? () {
                // إضافة منطق الحجز هنا
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('حجز المركبة'),
                    content: Text('تم الحجز بنجاح!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('إغلاق'),
                      ),
                    ],
                  ),
                );
              } : null,
              child: Text(vehicle.availability == 'available' ? 'احجز الآن' : 'غير متوفرة'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/car.dart';

class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;

  VehicleDetailScreen({required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Vehicle?>(
      future: Vehicle.getVehicleById(vehicleId), // جلب بيانات المركبة باستخدام الكلاس
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('تفاصيل المركبة'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('تفاصيل المركبة'),
            ),
            body: const Center(
              child: Text(
                'حدث خطأ أثناء تحميل بيانات المركبة',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        }

        final vehicle = snapshot.data;

        if (vehicle == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('تفاصيل المركبة'),
            ),
            body: const Center(
              child: Text(
                'المركبة غير موجودة',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(vehicle.carName),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // صورة المركبة
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(vehicle.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // تفاصيل المركبة
                Text(
                  vehicle.carName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'فئة المركبة: ${vehicle.vehicleClass}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'نوع الوقود: ${vehicle.fuelType}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'سعة المقاعد: ${vehicle.seatingCapacity}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'السعر لكل يوم: \$${vehicle.dailyRate.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'التوفر: ${vehicle.availability == "available" ? "متوفرة" : "غير متوفرة"}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),

                // زر الحجز
                ElevatedButton(
                  onPressed: vehicle.availability == 'available'
                      ? () {
                    // إضافة منطق الحجز هنا
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('حجز المركبة'),
                        content: Text('تم الحجز بنجاح!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text('إغلاق'),
                          ),
                        ],
                      ),
                    );
                  }
                      : null,
                  child: Text(
                      vehicle.availability == 'available' ? 'احجز الآن' : 'غير متوفرة'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}*/

