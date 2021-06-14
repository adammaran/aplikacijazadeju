import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfzr_biblioteka/model/book.dart';
import 'package:tfzr_biblioteka/reposiroty/book_repository.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _databaseReference = FirebaseFirestore.instance;

  String searchKey = '';

  @override
  Widget build(BuildContext context) {
    BookRepository bookRepo = BookRepository();
    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: (text) {
              setState(() {
                searchKey = text;
              });
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10), hintText: 'Uneti ime'),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: (searchKey == null || searchKey.trim() == '')
                ? _databaseReference.collection('books').snapshots()
                : _databaseReference
                    .collection('books')
                    .where('caseSearch', arrayContains: searchKey)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return SizedBox(
                    child: Center(
                      child: Text('Učitavanje... '),
                    ),
                  );
                case ConnectionState.none:
                  return Text('Korisnik nije pronadjen');
                default:
                  return new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return new Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.menu_book),
                              title: Text(document['title']),
                              subtitle: Text(document['description']),
                            ),
                            Text(
                                "Ostalo na stanju ${document['leftInStock']}"),
                            FirebaseAuth.instance.currentUser.uid != 'RX0IBC3visPjtTwzegN2QTI3UP72'
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: Text('IZNAJMI'),
                                  onPressed: () {
                                    bookRepo
                                        .addToRented(BookModel.create(document['id'], document['title'], document['description'], document['author'], document['leftInStock']));
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
                                            document['uid']);
                                      });
                                    },
                                  ),
                                ]),
                          ],
                        ),
                      );
                    }).toList(),
                  );
              }
            },
          ))
        ],
      ),
    );
  }
}
