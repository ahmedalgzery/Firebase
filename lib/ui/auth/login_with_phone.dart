import 'package:firebase/ui/auth/verfiy_code.dart';
import 'package:firebase/utils/utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final phoneNumberController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with phone '),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            TextFormField(
              controller: phoneNumberController,
              
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter number please ';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '+20 1000000000',
                  suffixIcon: Icon(Icons.phone_iphone)),
            ),
            const SizedBox(
              height: 80,
            ),
            RoundButton(
                title: 'Login',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_) {
                        setState(() {
                    loading = false;
                  });
                      },
                      verificationFailed: (error) {
                        setState(() {
                    loading = false;
                  });
                        Utils().tostMessage(message: error.toString());
                      },
                      codeSent: (verificationId, forceResendingToken) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerfiyCode(
                              verificationId: verificationId,
                            ),
                          ),
                          
                        );
                        setState(() {
                    loading = false;
                  });
                      },
                      codeAutoRetrievalTimeout: (error) {
                        Utils().tostMessage(message: error.toString());
                      });
                }),
          ],
        ),
      ),
    );
  }

}
