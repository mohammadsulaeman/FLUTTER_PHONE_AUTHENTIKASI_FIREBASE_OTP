import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone/loginScreen.dart';

class HomeController extends StatefulWidget {
  const HomeController({Key? key}) : super(key: key);

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/welcome.jpg"),
          Container(
            margin: const EdgeInsets.all(55),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>LoginScreen())
                  );
                },
                child: Text('Logout',style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 15
                ),
                ),
            ),
          ),
        ],
      ),
    );
  }
}
