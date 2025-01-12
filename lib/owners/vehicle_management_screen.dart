import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import 'dart:io'; // لاستدعاء File عند إدراج الصور
import 'package:image_picker/image_picker.dart'; // مكتبة اختيار الصور

class ManageCarPage extends StatefulWidget {
  final CarModel? car; // لاستقبال البيانات في حالة التعديل

  const ManageCarPage({super.key, this.car});

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
  late TextEditingController _distanceMeterController;
  late TextEditingController _fuelTypeController;
  late TextEditingController _plateNumberController;
  late TextEditingController _transmissionTypeController;
  bool _isAvailable = true;
  File? _imageFile; // لحفظ الصورة

  @override
  void initState() {
    super.initState();

    // التحقق مما إذا كانت الصفحة تحتوي على بيانات لتعديلها
    _nameController = TextEditingController(text: widget.car?.name ?? '');
    _fuelController = TextEditingController(text: widget.car?.category ?? '');
    _ownerController = TextEditingController(text: widget.car?.owner ?? '');
    _priceController =
        TextEditingController(text: widget.car?.pricePerDay.toString() ?? '');
    _seatsController = TextEditingController(text: widget.car?.seatsNumber ?? '');
    _distanceMeterController =
        TextEditingController(text: widget.car?.distanceMeter ?? '');
    _fuelTypeController = TextEditingController(text: widget.car?.fuelType ?? '');
    _plateNumberController =
        TextEditingController(text: widget.car?.plateNumber ?? '');
    _transmissionTypeController =
        TextEditingController(text: widget.car?.transmissionType ?? '');
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
        owner: _ownerController.text,
        images: _imageFile != null
            ? [_imageFile!.path] // تمثيل الصور في شكل نصوص
            : widget.car?.images ?? [],
        isBooking: _isAvailable,
        pricePerDay: double.parse(_priceController.text),
        distanceMeter: _distanceMeterController.text,
        fuelType: _fuelTypeController.text,
        plateNumber: _plateNumberController.text,
        seatsNumber: _seatsController.text,
        transmissionType: _transmissionTypeController.text,
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
                  decoration: const InputDecoration(labelText: 'اسم المركبة'),
                  validator: (value) =>
                  value!.isEmpty ? 'يرجى إدخال اسم المركبة' : null,
                ),
                TextFormField(
                  controller: _fuelController,
                  decoration: const InputDecoration(labelText: 'الفئة  '),
                  validator: (value) =>
                  value!.isEmpty ? 'يرجى إدخال الفئة ' : null,
                ),
                TextFormField(
                  controller: _ownerController,
                  decoration: const InputDecoration(labelText: 'الشركة المالكة'),
                  validator: (value) =>
                  value!.isEmpty ? 'يرجى إدخال اسم الشركة المالكة' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'السعر اليومي'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value!.isEmpty ? 'يرجى إدخال السعر اليومي' : null,
                ),
                TextFormField(
                  controller: _seatsController,
                  decoration: const InputDecoration(labelText: 'عدد المقاعد'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _distanceMeterController,
                  decoration:
                  const InputDecoration(labelText: 'المسافة المقطوعة'),
                  validator: (value) =>
                  value!.isEmpty ? 'يرجى إدخال المسافة المقطوعة' : null,
                ),
                TextFormField(
                  controller: _plateNumberController,
                  decoration: const InputDecoration(labelText: 'رقم اللوحة'),
                  validator: (value) =>
                  value!.isEmpty ? 'يرجى إدخال رقم اللوحة' : null,
                ),

                TextFormField(
                  controller: _transmissionTypeController,
                  decoration: const InputDecoration(labelText: 'ناقل الحركة'),
                ),
                Row(
                  children: [
                    const Text('حالة المركبة: '),
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('إدراج صورة'),
                    ),
                    const SizedBox(width: 10),
                    _imageFile != null
                        ? Image.file(
                      _imageFile!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveCar,
                  child: Text(widget.car == null ? 'إضافة' : 'تحديث'),
                ),
                const SizedBox(height: 10),
                if (widget.car != null)
                  ElevatedButton(
                    onPressed: _deleteCar,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('حذف المركبة'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
