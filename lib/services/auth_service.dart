import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // إرسال OTP إلى رقم الهاتف
  Future<void> sendOTP(String phoneNumber, Function(PhoneAuthCredential) verificationCompleted) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: (error) {
        print("Error: ${error.message}");
      },
      codeSent: (verificationId, forceResendingToken) {
        // هنا يمكنك إرسال الرمز عبر واجهة المستخدم ليقوم المستخدم بإدخاله
        print("Verification code sent to $phoneNumber");
      },
      codeAutoRetrievalTimeout: (verificationId) {
        print("Timeout: $verificationId");
      },
    );
  }

  // التحقق من الرمز وإتمام تسجيل الدخول
  Future<User?> signInWithOTP(String otp, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    try {
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error signing in with OTP: $e");
      return null;
    }
  }
}
