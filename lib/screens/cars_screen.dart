/*import 'package:flutter/material.dart';
import 'package:untitled2/models/car.dart';


class CarsScreen extends StatelessWidget {
  final List<Car> cars = [
    Car(name: 'Car 1', category: 'Sedan', price: 50, image: 'assets/images/car1.jpg'),
    Car(name: 'Car 2', category: 'SUV', price: 80, image: 'assets/images/car2.jpg'),
    // يمكنك إضافة المزيد من المركبات هنا
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Cars'),
      ),
      body: ListView.builder(
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final car = cars[index];
          return Card(
            child: ListTile(
              leading: Image.asset(car.image),
              title: Text(car.name),
              subtitle: Text('${car.category} - \$${car.price}/day'),
              onTap: () {
                // يمكنك إضافة الانتقال إلى تفاصيل السيارة هنا
              },
            ),
          );
        },
      ),
    );
  }
}
*/