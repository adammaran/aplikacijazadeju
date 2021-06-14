import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfzr_biblioteka/model/user.dart';
import 'package:tfzr_biblioteka/reposiroty/book_repository.dart';
import 'package:tfzr_biblioteka/reposiroty/user_repository.dart';

class BookList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookListState();
}

class BookListState extends State<BookList> {
  @override
  void initState() {
    print("initialising book list");
    super.initState();
  }

  @override
  void didUpdateWidget(BookList oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    BookRepository bookRepo = BookRepository();

    return Scaffold(
      floatingActionButton: FirebaseAuth.instance.currentUser.uid ==
              'RX0IBC3visPjtTwzegN2QTI3UP72'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/AddBook');
              },
              child: Icon(Icons.add),
            )
          : null,
      body: FutureBuilder(
          future: bookRepo.fetchAllBooks(),
          builder: (_, snap) {
            if (snap.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (_, index) {
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.menu_book),
                            title: Text(snap.data[index].title),
                            subtitle: Text(snap.data[index].description),
                          ),
                          Text(
                              "Ostalo na stanju ${snap.data[index].leftInStock}"),
                          FirebaseAuth.instance.currentUser.uid != 'RX0IBC3visPjtTwzegN2QTI3UP72'
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: Text('IZNAJMI'),
                                      onPressed: () {
                                        bookRepo.addToRented(snap.data[index]);
                                      },
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                      TextButton(
                                        child: Text('OBRIŠI'),
                                        onPressed: () {
                                          setState(() {
                                            bookRepo.deleteBook(
                                                snap.data[index].id);
                                          });
                                        },
                                      ),
                                    ]),
                        ],
                      ),
                    );
                  });
            } else
              return Center(
                child: Text("Učitava se..."),
              );
          }),
    );
  }
}
