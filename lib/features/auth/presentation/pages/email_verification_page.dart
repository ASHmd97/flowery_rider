// features/auth/presentation/pages/email_verification_page.dart
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: const Text('Email Vertication')),
            const SizedBox(height: 20),
            const Text(
              'Please enter your code that send to your\n email address.',
              textAlign: TextAlign.center,
            ),
            Pinput(
              length: 4,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Resend Verification Email'),
            ),
          ],
        ),
      ),
    );
  }
}
