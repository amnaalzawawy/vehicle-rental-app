import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  String? selectedCategory;
  String? selectedOwnerName;
  String? carName;
  String selectedPriceFilter = 'All';

  void setCategory(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setOwnerName(String ownerName) {
    selectedOwnerName = ownerName;
    notifyListeners();
  }

  void setCarName(String name) {
    carName = name;
    notifyListeners();
  }

  void setPriceFilter(String filter) {
    selectedPriceFilter = filter;
    notifyListeners();
  }
}
