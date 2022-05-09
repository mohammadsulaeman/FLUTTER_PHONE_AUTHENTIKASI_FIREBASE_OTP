import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:phone/otpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String dialCodeCountry = '+62';
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 28.0,right: 28.0),
              child: Image.asset("images/login.jpg"),
            ),
            Container(
              margin:const EdgeInsets.only(top: 10),
              child:const Center(
                child: Text('Phone (OTP) Authentikasi',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 400,
              height: 60,
              child: CountryCodePicker(
                onChanged: (country){
                  setState(() {
                    dialCodeCountry = country.dialCode!;
                  });
                },
                initialSelection: 'IT',
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10,right: 10,left: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                  ),
                  hintText: 'Phone Number',
                  labelText: 'Phone Number',
                  prefix: Padding(
                      padding: const EdgeInsets.all(4),
                  child: Text(dialCodeCountry),
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context)=>OTPController(
                            phone: _controller.text,
                            codeDigit: dialCodeCountry,
                          )),
                    );
                  },
                  child: Text('Next',style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white
                  ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
