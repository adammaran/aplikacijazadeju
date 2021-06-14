import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tfzr_biblioteka/model/book.dart';

class BookRepository {
  final _databaseReference = FirebaseFirestore.instance;

  void addBook(bookName, description, author, leftInStock) async {
    _databaseReference.collection('books').add({
      'title': bookName,
      'description': description,
      'author': author,
      'leftInStock': leftInStock,
      'timestamp': Timestamp.now(),
      'caseSearch': getKeyWordList(bookName)
    }).then((value) {
      _databaseReference
          .collection('books')
          .doc(value.id)
          .update({'id': value.id});
    }).catchError((error) => print('Failed to add Post: $error'));
  }

  Future<List<BookModel>> fetchAllBooks() async {
    var response = await _databaseReference.collection('books').get();
    List<BookModel> favoriteTitles = [];
    response.docs.forEach((i) {
      print(i.data());
      favoriteTitles.add(BookModel.create(
          i.data()['id'],
          i.data()['title'],
          i.data()['description'],
          i.data()['author'],
          int.parse(i.data()['leftInStock'])));
    });
    return favoriteTitles;
  }

  Future<void> deleteBook(id) async {
    FirebaseFirestore.instance
        .collection('books')
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('books')
            .doc(element.id)
            .delete()
            .then((value) => print("success"));
      });
    });
  }

  Future<bool> doesBookExist(String articleTitle) async {
    List<BookModel> favoriteTitles = await fetchAllBooks();
    if (favoriteTitles.contains(articleTitle)) {
      return true;
    } else
      return false;
  }

  Future<List<BookModel>> fetchRentedById() async {
    List<BookModel> returnable = [];
    await _databaseReference
        .collection('rented')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) async => {
              print(value.data()['rentals']),
              await _databaseReference
                  .collection('books')
                  .where('id', isEqualTo: value.data()['rentals'])
                  .get()
                  .then((value) => {
                        returnable.add(BookModel.create(
                            value.docs.first.id,
                            value.docs.first.data()['title'],
                            value.docs.first.data()['description'],
                            value.docs.first.data()['author'],
                            int.parse(value.docs.first.data()['leftInStock'])))
                      })
            });
    return returnable;
  }

  Future<void> addToRented(BookModel book) async {
    await _databaseReference
        .collection('rented')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'rentals': book.id});
  }

  List<String> getKeyWordList(keyword) {
    List<String> keyWords = [];
    String username = keyword;
    for (int i = 0; i < keyword.length; i++) {
      keyWords.add(username.substring(0, i + 1).toLowerCase());
    }
    return keyWords;
  }

  Future<void> deleteBookFromRented(id) async {
    _databaseReference
        .collection('rented')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .delete();
  }
}
