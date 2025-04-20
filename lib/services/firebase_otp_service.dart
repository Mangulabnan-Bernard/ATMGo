// import 'dart:async';
//
//
// class FirebaseOtpService {
//   // Send OTP
//   static Future<String?> sendOtp(String phoneNumber) async {
//     String? verificationId;
//
//     final Completer<String?> completer = Completer(); // Use a completer to return the verificationId
//
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // Auto-complete verification (not used in manual OTP flow)
//         // This can be triggered when automatic phone number verification completes.
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print('Verification failed: ${e.message}');
//         completer.completeError('Verification failed: ${e.message}'); // Show specific error
//       },
//       codeSent: (String vId, int? resendToken) {
//         verificationId = vId; // Store verification ID when OTP is sent
//         completer.complete(verificationId); // Complete the future with verificationId
//       },
//       codeAutoRetrievalTimeout: (String vId) {
//         verificationId = vId; // Store verification ID when auto retrieval times out
//         completer.complete(verificationId); // Complete the future with verificationId
//       },
//     );
//
//     // Await the completion of the completer and return verificationId
//     return completer.future;
//   }
//
//   // Verify OTP
//   static Future<bool> verifyOtp(String verificationId, String otp) async {
//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: otp,
//       );
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       return true; // OTP verified successfully
//     } catch (e) {
//       print('OTP verification failed: $e');
//       return false; // OTP verification failed
//     }
//   }
// }
