import 'package:flutter/material.dart';
import '../models/car.dart';

class CarCard extends StatelessWidget {
  final CarModel car;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CarCard({
    Key? key,
    required this.car,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المركبة
          if ((car.image ?? []).isNotEmpty)
            Image.network(
              (car.image ?? []).first.path,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ListTile(
            title: Text(car.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('التصنيف: ${car.category} - السعر اليومي: \$${car.pricePerDay}'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: Icon(Icons.edit, color: Colors.blue),
                label: Text("تعديل", style: TextStyle(color: Colors.blue)),
              ),
              TextButton.icon(
                onPressed: onDelete,
                icon: Icon(Icons.delete, color: Colors.red),
                label: Text("حذف", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
