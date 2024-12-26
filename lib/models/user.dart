class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final double? walletBalance;
  final String? profileImageBase64; // تخزين الصورة كـ Base64
  final String role; // إضافة دور المستخدم (أدمن أو مستخدم عادي)

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.walletBalance,
    this.profileImageBase64, // يمكن أن تكون null إذا لم توجد صورة
    required this.role, // دور المستخدم
  });

  // تحويل الكائن إلى خريطة (Map) لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'walletBalance': walletBalance,
      'profileImageBase64': profileImageBase64, // حفظ الصورة كـ Base64
      'role': role, // حفظ دور المستخدم
    };
  }

  // تحويل خريطة (Map) إلى كائن من نوع UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      walletBalance: map['walletBalance'],
      profileImageBase64: map['profileImageBase64'], // استرجاع الصورة كـ Base64
      role: map['role'], // استرجاع دور المستخدم
    );
  }

  // دالة copyWith لتعديل الخصائص بدون التأثير على الكائن الأصلي
  UserModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    double? walletBalance,
    String? profileImageBase64,
    String? role,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      walletBalance: walletBalance ?? this.walletBalance,
      profileImageBase64: profileImageBase64 ?? this.profileImageBase64,
      role: role ?? this.role, // إضافة دور المستخدم
    );
  }
}


