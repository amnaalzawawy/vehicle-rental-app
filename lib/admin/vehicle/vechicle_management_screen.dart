import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/admin/vehicle/vechicle_add_screen.dart';
import '../../models/car.dart';
import '../../providers/car_provider.dart';
import '../../widgets/custom_drawer.dart';



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
      drawer: CustomDrawer(),
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
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(car.name), // عرض اسم المركبة
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('فئة: ${car.category}'),
                            Text('مالك: ${car.owner}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddCarDialog(carToEdit: car),
                            );
                          },
                        ),
                      ),
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
