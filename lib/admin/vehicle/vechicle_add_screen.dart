
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:untitled2/models/car.dart'; // لاستيراد File


class AddCarDialog extends StatefulWidget {
  final CarModel? carToEdit;
  AddCarDialog({this.carToEdit});

  @override
  _AddCarDialogState createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {
  final _nameController = TextEditingController(); // الحقل الجديد
  final _categoryController = TextEditingController();
  final _ownerNameController = TextEditingController();
  List<String> _imageUrls = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.carToEdit != null) {
      _nameController.text = widget.carToEdit!.name; // تعيين القيمة الحالية
      _categoryController.text = widget.carToEdit!.category;
      _ownerNameController.text = widget.carToEdit!.ownerName;
      _imageUrls = widget.carToEdit!.imageUrls;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.carToEdit == null ? 'إضافة مركبة جديدة' : 'تعديل المركبة'),
      content: SingleChildScrollView(
        child: Column(
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
                  ownerName: _ownerNameController.text,
                  imageUrls: _imageUrls,
                  isBooking: false,
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
                      ownerName: _ownerNameController.text,
                      imageUrls: _imageUrls,
                      isBooking: widget.carToEdit!.isBooking,
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
        _ownerNameController.text.isNotEmpty;
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('يرجى ملء جميع الحقول')),
    );
  }
}
