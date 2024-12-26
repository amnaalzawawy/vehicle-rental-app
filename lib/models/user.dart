class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email; // البريد الإلكتروني
  final String passwordHash; // تجزئة كلمة المرور
  final double? walletBalance;
  late final String? profileImageBase64; // تخزين الصورة كـ Base64
  final String role; // دور المستخدم (أدمن أو مستخدم عادي)
  final String? socialLoginProvider; // طريقة التسجيل (مثل Google أو Facebook)

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email, // البريد الإلكتروني
    required this.passwordHash, // تجزئة كلمة المرور
    required this.walletBalance,
    this.profileImageBase64, // يمكن أن تكون null إذا لم توجد صورة
    required this.role, // دور المستخدم
    this.socialLoginProvider, // يمكن أن تكون null إذا لم يستخدم حساب اجتماعي
  });

  // تحويل الكائن إلى خريطة (Map) لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email, // حفظ البريد الإلكتروني
      'passwordHash': passwordHash, // حفظ تجزئة كلمة المرور
      'walletBalance': walletBalance,
      'profileImageBase64': profileImageBase64, // حفظ الصورة كـ Base64
      'role': role, // حفظ دور المستخدم
      'socialLoginProvider': socialLoginProvider, // حفظ طريقة التسجيل الاجتماعي
    };
  }

  // تحويل خريطة (Map) إلى كائن من نوع UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      email: map['email'], // استرجاع البريد الإلكتروني
      passwordHash: map['passwordHash'], // استرجاع تجزئة كلمة المرور
      walletBalance: map['walletBalance'],
      profileImageBase64: map['profileImageBase64'], // استرجاع الصورة كـ Base64
      role: map['role'], // استرجاع دور المستخدم
      socialLoginProvider: map['socialLoginProvider'], // استرجاع طريقة التسجيل الاجتماعي
    );
  }

  // دالة copyWith لتعديل الخصائص بدون التأثير على الكائن الأصلي
  UserModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email, // تعديل البريد الإلكتروني
    String? passwordHash, // تعديل تجزئة كلمة المرور
    double? walletBalance,
    String? profileImageBase64,
    String? role,
    String? socialLoginProvider, // تعديل طريقة التسجيل الاجتماعي
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email, // تعديل البريد الإلكتروني
      passwordHash: passwordHash ?? this.passwordHash, // تعديل كلمة المرور
      walletBalance: walletBalance ?? this.walletBalance,
      profileImageBase64: profileImageBase64 ?? this.profileImageBase64,
      role: role ?? this.role, // تعديل دور المستخدم
      socialLoginProvider: socialLoginProvider ?? this.socialLoginProvider, // تعديل طريقة التسجيل الاجتماعي
    );
  }
}
