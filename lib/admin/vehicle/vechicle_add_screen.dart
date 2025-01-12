import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:untitled2/models/car.dart';
import '../../providers/car_provider.dart';

class AddCarDialog extends StatefulWidget {
  final CarModel? carToEdit;

  const AddCarDialog({super.key, this.carToEdit});

  @override
  _AddCarDialogState createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _distanceMeterController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _seatsNumberController = TextEditingController();
  final _transmissionTypeController = TextEditingController();
  List<String> _imageUrls = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.carToEdit != null) {
      _nameController.text = widget.carToEdit!.name;
      _categoryController.text = widget.carToEdit!.category;
      _ownerNameController.text = widget.carToEdit!.owner;
      _priceController.text = widget.carToEdit!.pricePerDay.toString();
      _distanceMeterController.text = widget.carToEdit!.distanceMeter;
      _fuelTypeController.text = widget.carToEdit!.fuelType;
      _plateNumberController.text = widget.carToEdit!.plateNumber;
      _seatsNumberController.text = widget.carToEdit!.seatsNumber;
      _transmissionTypeController.text = widget.carToEdit!.transmissionType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.carToEdit == null ? 'إضافة مركبة جديدة' : 'تعديل المركبة'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'اسم المركبة'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'فئة المركبة'),
            ),
            TextField(
              controller: _ownerNameController,
              decoration: const InputDecoration(labelText: 'اسم المالك'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'السعر اليومي (بالدينار)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _distanceMeterController,
              decoration: const InputDecoration(labelText: 'المسافة المقطوعة (كم)'),
            ),
            TextField(
              controller: _fuelTypeController,
              decoration: const InputDecoration(labelText: 'نوع الوقود'),
            ),
            TextField(
              controller: _plateNumberController,
              decoration: const InputDecoration(labelText: 'رقم اللوحة'),
            ),
            TextField(
              controller: _seatsNumberController,
              decoration: const InputDecoration(labelText: 'عدد المقاعد'),
            ),
            TextField(
              controller: _transmissionTypeController,
              decoration: const InputDecoration(labelText: 'نوع ناقل الحركة'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text('تحميل الصور'),
            ),
            if (_imageUrls.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Image(
                        image: FileImage(File(_imageUrls[index])),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('إلغاء'),
        ),
        if (widget.carToEdit == null)
          TextButton(
            onPressed: () {
              if (_validateInputs()) {
                final newCar = CarModel(
                  id: DateTime.now().toString(),
                  name: _nameController.text,
                  category: _categoryController.text,
                  owner: _ownerNameController.text,
                  isBooking: false,
                  pricePerDay: double.parse(_priceController.text),
                  distanceMeter: _distanceMeterController.text,
                  fuelType: _fuelTypeController.text,
                  plateNumber: _plateNumberController.text,
                  seatsNumber: _seatsNumberController.text,
                  transmissionType: _transmissionTypeController.text,
                );

                Provider.of<CarProvider>(context, listen: false).addCar(newCar);
                Navigator.of(context).pop();
              } else {
                _showValidationError();
              }
            },
            child: const Text('إضافة'),
          )
        else
          Row(
            children: [
              TextButton(
                onPressed: () {
                  if (_validateInputs()) {
                    final updatedCar = CarModel(
                      id: widget.carToEdit!.id,
                      name: _nameController.text,
                      category: _categoryController.text,
                      owner: _ownerNameController.text,
                      isBooking: widget.carToEdit!.isBooking,
                      pricePerDay: double.parse(_priceController.text),
                      distanceMeter: _distanceMeterController.text,
                      fuelType: _fuelTypeController.text,
                      plateNumber: _plateNumberController.text,
                      seatsNumber: _seatsNumberController.text,
                      transmissionType: _transmissionTypeController.text,
                    );

                    Provider.of<CarProvider>(context, listen: false)
                        .updateCar(widget.carToEdit!.id, updatedCar);
                    Navigator.of(context).pop();
                  } else {
                    _showValidationError();
                  }
                },
                child: const Text('تعديل'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<CarProvider>(context, listen: false)
                      .deleteCar(widget.carToEdit!.id);
                  Navigator.of(context).pop();
                },
                child: const Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _imageUrls = pickedFiles.map((file) => file.path).toList();
      });
    }
  }

  bool _validateInputs() {
    return _nameController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty &&
        _ownerNameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        double.tryParse(_priceController.text) != null &&
        _distanceMeterController.text.isNotEmpty &&
        _fuelTypeController.text.isNotEmpty &&
        _plateNumberController.text.isNotEmpty &&
        _seatsNumberController.text.isNotEmpty &&
        _transmissionTypeController.text.isNotEmpty;
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('يرجى ملء جميع الحقول بشكل صحيح')),
    );
  }
}
