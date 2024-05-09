import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constant/Colors.dart';
import '../widgets/Apptext.dart';
import '../widgets/Container.dart';
import '../widgets/Textformfield.dart';
import 'otp screen.dart';

class Mobile_auth extends StatefulWidget {
  const Mobile_auth({Key? key});

  @override
  State<Mobile_auth> createState() => _Mobile_authState();
}

class _Mobile_authState extends State<Mobile_auth> {
  TextEditingController _phoneNumberController = TextEditingController();

  String _verificationId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(
              height: 60.h,
            ),
            SizedBox(
                height: 180.h,
                width: 180.w,
                child: Image.asset(
                    'assets/Screenshot_2024-05-01_194020-removebg-preview.png')),
            SizedBox(
              height: 30.h,
            ),

            //----------------------Phone number---------------------------------------------------------------------------

            AppText(
                text: "Enter Phone Number",
                size: 18,
                weight: FontWeight.w500,
                textcolor: black),
            SizedBox(
              height: 10.h,
            ),
            AppTextForm(
                vertical: 10,
                horizontal: 15,
                hintText: "Enter Phone Number*",
                weight: FontWeight.w400,
                size: 16,
                textcolor: Colors.grey,
                focusColor: black,
                enableColor: grey,
                validator: null,
                controller: _phoneNumberController,
                keybordType: TextInputType.phone),

            //---------------------------------------------------------------------------------------------------------

            SizedBox(
              height: 15.h,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "By Continuing, I agree to TotalX's", // First part of text
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: black,
                        fontSize: 14), // Color for the first part
                  ),
                  TextSpan(
                    text: '  Terms and condition', // Second part of text
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: blue,
                        fontSize: 14), // Color for the second part
                  ),
                  TextSpan(
                    text: '  &  ', // Second part of text
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: black,
                        fontSize: 14), // Color for the second part
                  ),
                  TextSpan(
                    text: 'privacy policy', // Second part of text
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: blue,
                        fontSize: 14), // Color for the second part
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.h,
            ),

            //----------------------- get otp------------------------------------------------------------------------

            InkWell(
              onTap: () async {
                await _verifyPhoneNumber('+91${_phoneNumberController.text}');
              },
              child: MyContainer(
                hight: 50,
                width: 200,
                text: AppText(
                    text: "Get OTP",
                    size: 18,
                    weight: FontWeight.w500,
                    textcolor: white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException error) {
          // Handle verification failed
          print("Verification Failed: ${error.message}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Verification Failed: ${error.message}"),
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to OTP screen
          setState(() {
            _verificationId = verificationId;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Otpscreen(
                verificationid: _verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Failed to verify phone number: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to verify phone number: $e"),
      ));
    }
  }
}
