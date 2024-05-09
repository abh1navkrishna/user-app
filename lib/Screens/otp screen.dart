import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_machine_test/Constant/Colors.dart';
import 'package:flutter_machine_test/widgets/Apptext.dart';
import 'package:flutter_machine_test/widgets/Container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'home page.dart';


class Otpscreen extends StatefulWidget {
  String verificationid;
  Otpscreen({super.key, required this.verificationid});

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  TextEditingController otpcontroller = TextEditingController();
  int _secondsRemaining = 60;
  late Timer _timer;
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          // Timer expired, you can add your logic here
        }
      });
    });
  }

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
                    'assets/Screenshot_2024-05-01_194037-removebg-preview.png')),
            SizedBox(
              height: 30.h,
            ),
            AppText(
                text: "OTP Verification",
                size: 18,
                weight: FontWeight.w500,
                textcolor: black),
            SizedBox(
              height: 10.h,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "Enter the verification code we just sent to your number +91 ********21", // First part of text
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: black,
                        fontSize: 14), // Color for the first part
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: SizedBox(
                height: 47.h,
                child: Pinput(
                  controller: otpcontroller,
                  keyboardType: TextInputType.number,
                  length: 6,
                ),
              ),
            ),
            Center(
              child: AppText(
                  text: '$_secondsRemaining Sec',
                  size: 16,
                  weight: FontWeight.w500,
                  textcolor: red),
            ),
            SizedBox(
              height: 15.h,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't Get OTP? ", // First part of text
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: black,
                          fontSize: 14), // Color for the first part
                    ),
                    TextSpan(
                      text: 'Resend', // Second part of text
                      style: GoogleFonts.inter(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          color: blue,
                          fontSize: 14), // Color for the second part
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () async {
                try {
                  PhoneAuthCredential credential =
                      await PhoneAuthProvider.credential(
                          verificationId: widget.verificationid,
                          smsCode: otpcontroller.text.toString());
                  FirebaseAuth.instance
                      .signInWithCredential(credential)
                      .then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Homeee(),
                        ));
                  });
                } catch (ex) {
                  log(ex.toString());
                }
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
}
