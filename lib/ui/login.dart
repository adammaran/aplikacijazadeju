import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tfzr_biblioteka/reposiroty/user_repository.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                padding: const EdgeInsets.all(8.0), child: Text('Login'))
          ],

        ),
        automaticallyImplyLeading: false,
      ),
      body: Builder(
          builder: (context) => Center(
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (!value.endsWith('@tfzr.rs')) {
                        return 'Email mora da bude @tfzr.rs';
                      } else
                        return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'E-mail',
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value.length <= 6) {
                        return 'Uneti više od 6 karaktera';
                      } else
                        return null;
                    },
                    decoration: const InputDecoration(
                        icon: Icon(Icons.lock), labelText: 'Password'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      userRepo.loginUser(_emailController, _passwordController);
                    },
                    child: Text('Login'),
                  ),
                  RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'Kreirajte novi nalog',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(
                                context, '/Register');
                          })
                  ]))
                ]),
              )),
    );
  }
}
