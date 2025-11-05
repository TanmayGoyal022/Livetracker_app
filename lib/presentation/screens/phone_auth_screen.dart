import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_tracking_app/core/services/auth_service.dart';
import 'package:live_tracking_app/presentation/screens/home_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneNumberController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final _authService = AuthService();
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            ElevatedButton(
              onPressed: () {
                _authService.verifyPhoneNumber(
                  _phoneNumberController.text,
                  (PhoneAuthCredential credential) async {
                    await FirebaseAuth.instance
                        .signInWithCredential(credential);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  (FirebaseAuthException e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(e.message ?? 'Verification failed')),
                    );
                  },
                  (String verificationId, int? resendToken) {
                    setState(() {
                      _verificationId = verificationId;
                    });
                  },
                  (String verificationId) {
                    setState(() {
                      _verificationId = verificationId;
                    });
                  },
                );
              },
              child: const Text('Send Verification Code'),
            ),
            if (_verificationId != null)
              Column(
                children: [
                  TextField(
                    controller: _smsCodeController,
                    decoration: const InputDecoration(labelText: 'SMS Code'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final credential = PhoneAuthProvider.credential(
                        verificationId: _verificationId!,
                        smsCode: _smsCodeController.text,
                      );
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
