import 'package:flutter/material.dart';

class CommonProvider with ChangeNotifier {
  //! connectivity
  bool _isCheckingConnectivity = false;
  bool get isCheckingConnectivity => _isCheckingConnectivity;

  void setIsCheckingConnectivity(bool isChecking) {
    _isCheckingConnectivity = isChecking;
    notifyListeners();
  }

  //!dropdown
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void setOpen(bool isOpen) {
    _isOpen = isOpen;
    notifyListeners();
  }

  void toggleDropdown() {
    _isOpen = !_isOpen;
    notifyListeners();
  }

  List<DropdownMenuItem<String>> _filteredItems = [];
  List<DropdownMenuItem<String>> get filteredItems => _filteredItems;

  void setFilteredItems(List<DropdownMenuItem<String>> items) {
    _filteredItems = items;
    notifyListeners();
  }

  String _searchDropdownText = '';
  String get searchDropdownText => _searchDropdownText;

  void setSearchText(String text) {
    _searchDropdownText = text;
    notifyListeners();
  }

  //! clear search icon
  String _searchText = '';

  String get searchText => _searchText;

  void updateText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void clearText() {
    _searchText = '';
    notifyListeners();
  }
}
