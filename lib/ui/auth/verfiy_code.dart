// ignore_for_file: use_build_context_synchronously

import 'dart:html';

import 'package:firebase/ui/posts/post_screen.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerfiyCode extends StatefulWidget {
  const VerfiyCode({super.key, required this.verificationId});
  final verificationId;
  @override
  State<VerfiyCode> createState() => _VerfiyCodeState();
}

class _VerfiyCodeState extends State<VerfiyCode> {
  final smsNumberController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verfiy Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            TextFormField(
              controller: smsNumberController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter number please ';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '6 digit code',
                  suffixIcon: Icon(Icons.phone_iphone)),
            ),
            const SizedBox(
              height: 80,
            ),
            RoundButton(
              title: 'Verfiy',
              onTap: () async {
                setState(() {
                  loading = true;
                });
                final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: smsNumberController.text.toString());
                try {
                  await auth.signInWithCredential(credential);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostScreen(),
                    ),
                  );
                } catch (e) {
                  setState(() {
                    loading = true;
                  });
                  Utils().tostMessage(
                    message: e.toString(),
                  );
                }
              },
              loading: loading,
            ),
          ],
        ),
      ),
    );
  }
}
