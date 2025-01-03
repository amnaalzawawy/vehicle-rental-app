import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:untitled2/models/car.dart';
import '../../providers/car_provider.dart';

class AddCarDialog extends StatefulWidget {
  final CarModel? carToEdit;

  AddCarDialog({this.carToEdit});

  @override
  _AddCarDialogState createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _priceController = TextEditingController(); // حقل السعر
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
      // _imageUrls = widget.carToEdit!.image;
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
              decoration: InputDecoration(labelText: 'اسم المركبة'),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'فئة المركبة'),
            ),
            TextField(
              controller: _ownerNameController,
              decoration: InputDecoration(labelText: 'اسم المالك'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'السعر اليومي (بالدينار)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('تحميل الصور'),
            ),
            if (_imageUrls.isNotEmpty)
              Container(
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
          child: Text('إلغاء'),
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
                  // image: _imageUrls,
                  isBooking: false,
                  pricePerDay: double.parse(_priceController.text),
                );

                Provider.of<CarProvider>(context, listen: false).addCar(newCar);
                Navigator.of(context).pop();
              } else {
                _showValidationError();
              }
            },
            child: Text('إضافة'),
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
                      // image: _imageUrls,
                      isBooking: widget.carToEdit!.isBooking,
                      pricePerDay: double.parse(_priceController.text),
                    );

                    Provider.of<CarProvider>(context, listen: false)
                        .updateCar(widget.carToEdit!.id, updatedCar);
                    Navigator.of(context).pop();
                  } else {
                    _showValidationError();
                  }
                },
                child: Text('تعديل'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<CarProvider>(context, listen: false)
                      .deleteCar(widget.carToEdit!.id);
                  Navigator.of(context).pop();
                },
                child: Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
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
        double.tryParse(_priceController.text) != null;
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('يرجى ملء جميع الحقول بشكل صحيح')),
    );
  }
}
