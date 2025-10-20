import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_management_app/auth/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: IconButton(
            onPressed: () async {
              await AuthService().signInWithGoogle();
            },
            icon: FaIcon(FontAwesomeIcons.google, size: 20),
          ),
        ),
      ),
    );
  }
}
