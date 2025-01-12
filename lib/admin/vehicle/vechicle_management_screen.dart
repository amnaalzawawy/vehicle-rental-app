import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/admin/vehicle/vechicle_add_screen.dart';
import '../../models/car.dart';
import '../../providers/car_provider.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_user_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CarCard extends StatefulWidget {
  final CarModel car;
  final VoidCallback onEditPressed; // تمرير الحدث عند الضغط على زر التعديل
  final VoidCallback onDeletePressed; // تمرير الحدث عند الضغط على زر الحذف

  CarCard({required this.car, required this.onEditPressed, required this.onDeletePressed});

  @override
  _CarCardState createState() => _CarCardState();
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
        setState(() {
          imageURL = null;
        });
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
    var car = widget.car;

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xfff78B00), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          imageURL != null
              ? ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Image.network(
              imageURL!,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
          )
              : Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  car.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 5),
                Text(
                  'الفئة: ${car.category}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 5),
                Text(
                  'السعر: ${car.pricePerDay.toStringAsFixed(2)} د.ل',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),
                // أزرار التعديل والحذف
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: widget.onEditPressed,
                      color: const Color(0xfff78B00), // اللون البرتقالي
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: widget.onDeletePressed,
                      color: Colors.red, // اللون الأحمر
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CarScreen extends StatefulWidget {
  @override
  _CarScreenState createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    try {
      await Provider.of<CarProvider>(context, listen: false).fetchCars();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تحميل المركبات: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المركبات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddCarDialog(),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer2(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                hintText: 'ابحث حسب الفئة أو اسم المالك أو اسم المركبة',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Consumer<CarProvider>(
              builder: (context, carProvider, child) {
                final List<CarModel> filteredCars = carProvider.searchCars(_searchController.text);

                if (filteredCars.isEmpty) {
                  return const Center(child: Text('لا توجد نتائج'));
                }

                return ListView.builder(
                  itemCount: filteredCars.length,
                  itemBuilder: (context, index) {
                    final CarModel car = filteredCars[index];
                    return CarCard(
                      car: car,
                      onEditPressed: () {
                        // فتح نافذة تعديل المركبة
                        showDialog(
                          context: context,
                          builder: (context) => AddCarDialog(carToEdit: car), // إرسال السيارة المعدلة
                        );
                      },
                      onDeletePressed: () {
                        // إضافة الكود الخاص بحذف المركبة
                        Provider.of<CarProvider>(context, listen: false).deleteCar(car.id);
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
