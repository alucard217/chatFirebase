import 'package:chat/Pages/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat/services/Registration_Service.dart';

import 'MainChatPage.dart';

class RegistrationPage extends StatelessWidget {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  final RegistrationService _registrationService = RegistrationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Container(
          width: 300,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusGeometry.circular(15),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                "Welcome!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 100),
              _createTextField(context, emailController, "E-mail"),
              _createTextField(context, passwordController, "Password"),
              SizedBox(height: 50),
              _createLoginButton(context),
              SizedBox(height: 15),
              Stack(
                children: [
                  Center(child: Text("Already have an account?")),
                  Center(child: TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  }, child: Text("You can log in!")))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createTextField(
      BuildContext context,
      TextEditingController controller, String hintText
      ) {
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(15),
        color: Theme.of(context).colorScheme.tertiary,
      ),
      margin: EdgeInsetsGeometry.symmetric(vertical: 10),
      padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hint: Text(hintText, style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
        ),
      ),
    );
  }

  Widget _createLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _registrationService.registerUser(
          emailController.text,
          passwordController.text,
        );
        emailController.clear();
        passwordController.clear();
        Navigator.push(context, MaterialPageRoute(builder: (context) => UsersChat()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      child: Text(
        "Register",
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}