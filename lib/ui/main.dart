import 'package:flutter/material.dart';
import 'package:tfzr_biblioteka/reposiroty/user_repository.dart';
import 'package:tfzr_biblioteka/ui/book_list.dart';
import 'package:tfzr_biblioteka/ui/rented_books_list.dart';
import 'package:tfzr_biblioteka/ui/search.dart';
import 'package:tfzr_biblioteka/ui/user_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  int _currentIndex = 0;

  final _pageOptions = [BookList(), SearchPage(), RentalBookPage(), UserPage()];

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
                padding: const EdgeInsets.all(8.0),
                child: Text('TFZR Biblioteka'))
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              UserRepository userRepo = UserRepository(context: context);
              userRepo.signOut();
              Navigator.pushReplacementNamed(context, "/Login");
            },
            child: Icon(Icons.logout),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: _pageOptions[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        iconSize: 28,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Knjige',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pretraga',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Iznajmljene knjige',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
