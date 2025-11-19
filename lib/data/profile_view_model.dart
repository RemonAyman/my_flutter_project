import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  // User data
  String name = '';
  String email = '';
  String phone = '';
  String country = '';
  int age = 0;
  String profileImage = ''; // URL or path to image

  // Update methods
  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  void updatePhone(String newPhone) {
    phone = newPhone;
    notifyListeners();
  }

  void updateCountry(String newCountry) {
    country = newCountry;
    notifyListeners();
  }

  void updateAge(int newAge) {
    age = newAge;
    notifyListeners();
  }

  void updateProfileImage(String imagePath) {
    profileImage = imagePath;
    notifyListeners();
  }

  // Save all user data
  void saveUserData() {
    // TODO: Connect to database later
    print('User data saved:');
    print('Name: $name');
    print('Email: $email');
    print('Phone: $phone');
    print('Country: $country');
    print('Age: $age');
    print('Profile Image: $profileImage');
    notifyListeners();
  }

  // Load user data
  void loadUserData() {
    // TODO: Load from database later
    print('Loading user data from database...');
    notifyListeners();
  }
}
