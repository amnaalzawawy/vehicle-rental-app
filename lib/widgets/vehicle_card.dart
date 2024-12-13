import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double pricePerDay;
  final bool isAvailable;
  final String carId;  // إضافة carId لتمريره إلى شاشة التفاصيل
  final VoidCallback onTap;

  const VehicleCard({
    required this.imageUrl,
    required this.name,
    required this.pricePerDay,
    required this.isAvailable,
    required this.carId, // إضافة carId
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عرض الصور في صورة متحركة
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                // عرض الصورة المركبة (محتوى متغير حسب المركبة)
                PageView(
                  children: [Image.network(imageUrl, fit: BoxFit.cover)],
                ),
                // إذا كانت المركبة غير متوفرة، يتم تغطية الصورة بكود الإشارة إلى "غير متوفرة"
                if (!isAvailable)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      child: Center(
                        child: Text(
                          'غير متوفرة',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المركبة
                Text(name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                // عرض السعر اليومي
                Text('السعر لكل يوم: \$${pricePerDay.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                // زر "احجز الآن" إذا كانت المركبة متوفرة
                ElevatedButton(
                  onPressed: isAvailable
                      ? () {
                    // عند الضغط على الزر، يتم الانتقال إلى شاشة تفاصيل المركبة
                    onTap();
                  }
                      : null, // إذا كانت المركبة غير متوفرة، لا يعمل الزر
                  child: const Text('احجز الآن'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
