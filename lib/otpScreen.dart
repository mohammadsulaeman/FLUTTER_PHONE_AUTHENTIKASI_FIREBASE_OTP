import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phone/homeScreen.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPController extends StatefulWidget {
  final String phone;
  final String codeDigit;
  OTPController({required this.phone, required this.codeDigit });

  @override
  State<OTPController> createState() => _OTPControllerState();
}

class _OTPControllerState extends State<OTPController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFokus = FocusNode();
  String? verificationCode;
  final BoxDecoration pinOTPCodeBoxDecoration = BoxDecoration(
    color: Colors.blueAccent,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.grey
    ),
  );

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  verifyPhoneNumber() async{
    await Firebase.initializeApp();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.codeDigit + widget.phone}',
        verificationCompleted: (PhoneAuthCredential crediential) async{
          await FirebaseAuth.instance
              .signInWithCredential(crediential)
              .then((value) {
             if(value.user !=null)
               {
                 Navigator.of(context).push(
                   MaterialPageRoute(builder: (context)=>HomeController())
                 );
               }
          });
        },
        verificationFailed: (FirebaseAuthException e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.message.toString()),
            duration: Duration(seconds: 5),
          ),
          );
        },
        codeSent: (String vID, int? resendToken){
          setState(() {
            verificationCode = vID;
          });
        },
        timeout: Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String vID) {
          setState(() {
            verificationCode = vID;
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title:const Text('OTP Phone Number Verification',style: TextStyle(
          fontFamily: "Times New Roman",
          fontSize: 18.0
        ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
            child: Image.asset("images/otp.png"),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Center(
              child: GestureDetector(
                onTap: (){
                  verifyPhoneNumber();
                },
                child: Text(
                  'Verifying : ${widget.codeDigit}${widget.phone}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 20,color: Colors.cyanAccent
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(40.0),
            child: PinPut(
                fieldsCount: 6,
            textStyle: TextStyle(fontSize: 18.0,color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinOTPCodeFokus,
              controller: _pinOTPCodeController,
              submittedFieldDecoration: pinOTPCodeBoxDecoration,
              selectedFieldDecoration: pinOTPCodeBoxDecoration,
              pinAnimationType: PinAnimationType.rotation,
              onSubmit: (pin) async{
                  try{
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                        verificationId: verificationCode!,
                        smsCode: pin))
                        .then((value) => {
                          if(value.user !=null)
                            {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=>HomeController(
                                ))
                              )
                            }
                    });
                  }catch(error){
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Invalid Code OTP'),
                    duration: Duration(seconds: 5),));
                  }
              },
            ),
          )
        ],
      ),
    );
  }
}
