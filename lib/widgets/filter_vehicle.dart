import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterApply;

  const FilterWidget({super.key, required this.onFilterApply});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String? selectedCategory; // فئة المركبة
  String? selectedOwner; // اسم المالك
  String? selectedPriceRange; // نطاق السعر (سلسلة نصية مثل "<100")
  List<String> categories = []; // قائمة الفئات التي سيتم تحديثها من Firestore
  List<String> owners = []; // قائمة المالكين التي سيتم تحديثها من Firestore

  // استرجاع الفئات من Firestore
  Future<void> _fetchCategories() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('cars').get();
      final Set<String> fetchedCategories = {}; // استخدام Set لتجنب التكرار
      for (var doc in querySnapshot.docs) {
        // التأكد من وجود الحقل category
        if (doc.data().containsKey('category')) {
          final category = doc['category'];
          if (category != null && category.isNotEmpty) {
            fetchedCategories.add(category);
          }
        }
      }
      setState(() {
        categories = fetchedCategories.toList();
      });
    } catch (e) {
      print('فشل في جلب الفئات: $e');
    }
  }


  // استرجاع أسماء المالكين من Firestore (مجموعة users)
  Future<void> _fetchOwners() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      final Set<String> fetchedOwners = {}; // استخدام Set لتجنب التكرار
      for (var doc in querySnapshot.docs) {
        final role = doc['role']; // قراءة الحقل role
        if (role == 'owner') {
          final firstName = doc['firstName'];
          final lastName = doc['lastName'];
          if (firstName != null && lastName != null && firstName.isNotEmpty && lastName.isNotEmpty) {
            fetchedOwners.add('$firstName $lastName'); // دمج الاسم الأول والأخير
          }
        }
      }
      setState(() {
        owners = fetchedOwners.toList(); // تحويل Set إلى List
      });
    } catch (e) {
      print('فشل في جلب أسماء المالكين: $e');
    }
  }

  void applyFilters() {
    widget.onFilterApply({
      'category': selectedCategory,
      'owner': selectedOwner,
      'priceRange': selectedPriceRange,
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // استرجاع الفئات عند تحميل الواجهة
    _fetchOwners(); // استرجاع المالكون عند تحميل الواجهة
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // منحنيات أنيقة
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView( // يسمح بالتمرير في حال الحاجة
          scrollDirection: Axis.vertical, // التمرير عمودي
          child: Column(
            children: [
              // فلتر الفئة
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: categories.isEmpty // التحقق من أن الفئات تم تحميلها
                    ? const CircularProgressIndicator() // عرض تحميل أثناء جلب الفئات
                    : DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'فئة المركبة',
                    labelStyle: const TextStyle(color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
              // فلتر المالك
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: owners.isEmpty // التحقق من أن المالكين تم تحميلهم
                    ? const CircularProgressIndicator() // عرض تحميل أثناء جلب المالكون
                    : DropdownButtonFormField<String>(
                  value: selectedOwner,
                  decoration: InputDecoration(
                    labelText: 'مالك المركبة',
                    labelStyle: const TextStyle(color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                  items: owners.map((owner) {
                    return DropdownMenuItem(
                      value: owner,
                      child: Text(owner),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOwner = value;
                    });
                  },
                ),
              ),
              // فلتر السعر اليومي
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedPriceRange,
                  decoration: InputDecoration(
                    labelText: 'السعر اليومي',
                    labelStyle: const TextStyle(color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                  items: [
                    '<100',
                    '<200',
                    '<500',
                  ].map((priceRange) {
                    return DropdownMenuItem(
                      value: priceRange,
                      child: Text(priceRange),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPriceRange = value;
                    });
                  },
                ),
              ),
              // زر تطبيق الفلاتر
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // لون الزر
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // منحنى الزر
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                onPressed: applyFilters,
                child: const Text(
                  'تطبيق',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}