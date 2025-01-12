import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/car.dart';

class CarCard extends StatefulWidget {
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
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  String? imageURL;
  void getImageURL() async {
    if (widget.car.images.isNotEmpty) {
      try {
        var url = await Supabase.instance.client.storage
            .from("cars")
            .createSignedUrl(widget.car.images[0].replaceAll("cars/", ""), 60000);
        setState(() {
          imageURL = url;
        });
      } catch (e) {
        // Handle any errors here
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getImageURL();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المركبة
          if (imageURL != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
              child: Image.network(
                imageURL!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ListTile(
            title: Text(widget.car.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('التصنيف: ${widget.car.category} - السعر اليومي: \$${widget.car.pricePerDay}'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: widget.onEdit,
                icon: const Icon(Icons.edit, color: Colors.blue),
                label: const Text("تعديل", style: TextStyle(color: Colors.blue)),
              ),
              TextButton.icon(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text("حذف", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
