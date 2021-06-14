import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserRepository {
  final _databaseReference = FirebaseFirestore.instance;

  BuildContext context;

  UserRepository({this.context});

  void loginUser(_emailController, _passwordController) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.pushReplacementNamed(context, '/Home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        final snackBar = SnackBar(content: Text('Korisnik nije pronadjen'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'wrong-password') {
        final snackBar = SnackBar(content: Text('Pogrešna šifra'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> createUser(_emailController, _passwordController,
      _usernameController, _rePasswordController) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      addUserToDB(_usernameController, _emailController);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {}
    } catch (e) {
      print(e);
      _emailController.text = "";
      _usernameController.text = "";
      _passwordController.text = "";
      _rePasswordController.text = "";
    }
  }

  void addUserToDB(_usernameController, _emailController) async {
    await _databaseReference
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'uid': FirebaseAuth.instance.currentUser.uid,
      'username': _usernameController.text,
      'email': _emailController.text,
      'userType': 'student'
    });
    Navigator.pushReplacementNamed(context, '/Home');
  }

  Future getUser(String userUid) async {
    return _databaseReference.collection('users').doc(userUid).get();
  }
}
