import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfzr_biblioteka/reposiroty/book_repository.dart';

class AddBookPage extends StatelessWidget {
  final _bookNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _authorController = TextEditingController();
  final _leftInStockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(8.0), child: Text('Dodavanje knjige'))
          ],

        ),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              TextFormField(
                controller: _bookNameController,
                decoration: InputDecoration(
                    icon: Icon(Icons.drive_file_rename_outline),
                    border: UnderlineInputBorder(),
                    labelText: 'Ime knjige'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    icon: Icon(Icons.description),
                    border: UnderlineInputBorder(),
                    labelText: 'Opis knjige'),
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    border: UnderlineInputBorder(),
                    labelText: 'Autor knjige'),
              ),
              TextFormField(
                controller: _leftInStockController,
                decoration: InputDecoration(
                    icon: Icon(Icons.note),
                    border: UnderlineInputBorder(),
                    labelText: 'Kolicina u zalihama'),
              ),
              ElevatedButton(
                  onPressed: () {
                    BookRepository bookrepo = BookRepository();
                    bookrepo.addBook(
                        _bookNameController.text,
                        _descriptionController.text,
                        _authorController.text,
                        _leftInStockController.text);
                    Navigator.popAndPushNamed(context, '/Home');
                  },
                  child: Text('Dodaj knjigu'))
            ],
          ),
        ),
      ),
    );
  }
}
