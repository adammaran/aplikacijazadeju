import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tfzr_biblioteka/reposiroty/user_repository.dart';

import 'main.dart';

class RegisterPageState extends StatefulWidget {
  RegisterPage createState() => RegisterPage();
}

class RegisterPage extends State<RegisterPageState> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  String userType = 'student';

  @override
  Widget build(BuildContext context) {
    UserRepository userRepo = UserRepository(context: context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                'https://i.imgur.com/wRaHYNO.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Registracija'))
            ],
          ),
          automaticallyImplyLeading: true,
        ),
        body: Builder(
          builder: (context) => Center(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'E-mail',
                  ),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Korisničko ime',
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Šifra',
                  ),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _rePasswordController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Ponoviti šifru',
                  ),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_passwordController.text !=
                        _rePasswordController.text) {
                      showSnackBar(context, 'Šifre nisu iste');
                    } else if (!_emailController.text.endsWith('@tfzr.rs')) {
                      showSnackBar(
                          context, 'Email mora da sadrži \'@tfzr.rs\'');
                    } else {
                      userRepo.createUser(_emailController, _passwordController,
                          _usernameController, _rePasswordController);
                    }
                  },
                  child: Text('Registruj se'),
                ),
              ],
            ),
          ),
        ));
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
