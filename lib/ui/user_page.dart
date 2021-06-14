import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfzr_biblioteka/reposiroty/user_repository.dart';

class UserPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UserRepository userRepo = UserRepository(context: context);
    return Scaffold(
      body: FutureBuilder(
          future: userRepo.getUser(FirebaseAuth.instance.currentUser.uid),
          builder: (context, user) {
            if (user.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Učitavanje...'),
              );
            } else {
              return Center(
                  child: Column(
                    children: [
                      Image.network(
                          'https://hatrabbits.com/wp-content/uploads/2017/01/random.jpg'),
                      Text(user.data.data()['username']),
                    ],
                  ));
            }
          }),
    );
  }

}