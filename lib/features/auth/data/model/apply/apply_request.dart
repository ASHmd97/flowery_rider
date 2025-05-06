// features/auth/data/model/apply/apply_request.dart
import 'dart:convert';
import 'dart:io';

class ApplyRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String countryCode;
  final String gender;
  final String vehicleType;
  final String vehicleNumber;
  final String idNumber;
  final String password;
  final File? licensePhoto;
  final File? idPhoto;

  ApplyRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.gender,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.idNumber,
    required this.password,
    this.licensePhoto,
    this.idPhoto,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'country_code': countryCode,
      'gender': gender,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'id_number': idNumber,
      'password': password,
    };
  }

  // Helper method to create multipart request
  Map<String, dynamic> toMultipartRequestData() {
    final data = toJson();
    return data;
  }
}