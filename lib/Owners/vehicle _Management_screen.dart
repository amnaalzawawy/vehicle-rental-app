import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import 'dart:io'; // لاستدعاء File عند إدراج الصور
import 'package:image_picker/image_picker.dart'; // مكتبة اختيار الصور

class ManageCarPage extends StatefulWidget {
  final CarModel? car; // لاستقبال البيانات في حالة التعديل

  const ManageCarPage({Key? key, this.car}) : super(key: key);

  @override
  State<ManageCarPage> createState() => _ManageCarPageState();
}

class _ManageCarPageState extends State<ManageCarPage> {
  final _formKey = GlobalKey<FormState>();

  // المتغيرات الخاصة بالحقول
  late TextEditingController _nameController;
  late TextEditingController _fuelController;
  late TextEditingController _ownerController;
  late TextEditingController _priceController;
  late TextEditingController _seatsController;
  bool _isAvailable = true;
  File? _imageFile; // لحفظ الصورة

  @override
  void initState() {
    super.initState();

    // التحقق مما إذا كانت الصفحة تحتوي على بيانات لتعديلها
    _nameController = TextEditingController(text: widget.car?.name ?? '');
    _fuelController = TextEditingController(text: widget.car?.category ?? '');
    _ownerController = TextEditingController(text: widget.car?.ownerName ?? '');
    _priceController =
        TextEditingController(text: widget.car?.pricePerDay.toString() ?? '');
    _seatsController = TextEditingController();
    _isAvailable = widget.car?.isBooking ?? true;
  }

  // اختيار صورة
  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // دالة لحفظ البيانات
  void _saveCar() async {
    if (_formKey.currentState!.validate()) {
      final carProvider = Provider.of<CarProvider>(context, listen: false);


      final newCar = CarModel(
        id: widget.car?.id ?? '',
        name: _nameController.text,
        category: _fuelController.text,
        ownerName: _ownerController.text,
        image: _imageFile != null
            ? [_imageFile!] // تمثيل الصور في شكل نصوص
            : widget.car?.image ?? [],
        isBooking: _isAvailable,
        pricePerDay: double.parse(_priceController.text),
      );

      if (widget.car == null) {
        // إضافة مركبة جديدة
        carProvider.addCar(newCar);
      } else {
        // تحديث البيانات
        carProvider.updateCar(widget.car!.id, newCar);
      }

      Navigator.pop(context); // العودة إلى الصفحة الرئيسية
    }
  }

  // دالة لحذف المركبة
  void _deleteCar() {
    if (widget.car != null) {
      final carProvider = Provider.of<CarProvider>(context, listen: false);
      carProvider.deleteCar(widget.car!.id);
      Navigator.pop(context); // العودة إلى الصفحة الرئيسية بعد الحذف
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car == null ? 'إضافة مركبة' : 'تعديل المركبة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'اسم المركبة'),
                  validator: (value) =>
                  value!.isEmpty ? 'يرجى إدخال اسم المركبة' : null,
                ),
                TextFormField(
                  controller: _fuelController,
                  decoration: InputDecoration(labelText: 'نوع الوقود'),
                  validator: (value) =>
                  value!.isEmpty ? 'يرجى إدخال نوع الوقود' : null,
                ),
                TextFormField(
                  controller: _ownerController,
                  decoration: InputDecoration(labelText: 'الشركة المالكة'),
                  validator: (value) =>
                  value!.isEmpty ? 'يرجى إدخال اسم الشركة المالكة' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'السعر اليومي'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value!.isEmpty ? 'يرجى إدخال السعر اليومي' : null,
                ),
                TextFormField(
                  controller: _seatsController,
                  decoration: InputDecoration(labelText: 'عدد المقاعد'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Text('حالة المركبة: '),
                    Switch(
                      value: _isAvailable,
                      onChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // زر اختيار الصورة
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('إدراج صورة'),
                    ),
                    SizedBox(width: 10),
                    _imageFile != null
                        ? Image.file(
                      _imageFile!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                        : SizedBox(),
                  ],
                ),
                SizedBox(height: 20),
                // زر الحفظ
                ElevatedButton(
                  onPressed: _saveCar,
                  child: Text(widget.car == null ? 'إضافة' : 'تحديث'),
                ),
                SizedBox(height: 10),
                // زر الحذف
                if (widget.car != null)
                  ElevatedButton(
                    onPressed: _deleteCar,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('حذف المركبة'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
