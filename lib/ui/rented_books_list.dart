import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfzr_biblioteka/reposiroty/book_repository.dart';

class RentalBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RentalBookState();
}

class _RentalBookState extends State<RentalBookPage> {
  BookRepository bookRepo = BookRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: bookRepo.fetchRentedById(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Učitava se"),
          );
        } else if (!snap.hasData) {
          return Center(
            child: Text("Nema podataka"),
          );
        }
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
                    Text("Ostalo na stanju ${snap.data[index].leftInStock}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: Text('VRATI'),
                          onPressed: () {
                            setState(() {
                              bookRepo.deleteBookFromRented(snap.data[index]);
                            });
                          },
                        ),
                        SizedBox(width: 8),
                      ],
                    )
                  ],
                ),
              );
            });
      },
    ));
  }
}
