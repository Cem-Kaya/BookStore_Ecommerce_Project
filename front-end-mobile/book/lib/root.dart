import 'package:bookstore/services/root_index.dart';
import 'package:bookstore/services/user_logged_data.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/pages/homepage.dart';
import 'package:bookstore/pages/profile.dart';
import 'package:bookstore/pages/sell_product.dart';
import 'package:bookstore/pages/sign_in.dart';
import 'package:bookstore/pages/suggestions.dart';
import 'package:bookstore/pages/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/basket.dart';
import 'pages/favorites.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  var routes = [
    const HomePage(),
    const BasketPage(),
    const Favorites(),
    const Suggestions(),
    const SellProduct(),
    const SignIn(),
  ];

  Future<void> walk() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('walked'));
    // set value
    if (prefs.getBool('walked') == false || prefs.getBool('walked') == null) {
      prefs.setBool('walked', true);
      Navigator.pushNamed(context, '/walk');
    }
  }

  @override
  void initState() {
    super.initState();
    walk();
    // obtain shared preferences
  }

  //BottomNavigation
  static int _selectedBottomTabIndex = 0;
  bool temp = false;

  /*void _onBottomTabPress(int index) {
    setState(() {
      if (temp && index == 5) {
        Navigator.pushNamed(context, '/profile');
      } else {
        _selectedBottomTabIndex = index;
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    Function login = Provider.of<logged_in_user>(context).getUser;
    Function select_index = Provider.of<ClassRoot>(context).getRoot;
    Function change_index = Provider.of<ClassRoot>(context).changeRoot;
    _selectedBottomTabIndex = select_index();

    if (login() == "") {
      temp = false;
    } else {
      temp = true;
    }
    return Scaffold(
      body: routes[_selectedBottomTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: 'Basket',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorites',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Suggestions',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              label: 'Sell Product',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
              backgroundColor: Colors.green)
        ],
        currentIndex: _selectedBottomTabIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (_selectedBottomTabIndex) {
          if (temp && _selectedBottomTabIndex == 5) {
            Navigator.pushNamed(context, '/profile');
          } else {
            change_index(_selectedBottomTabIndex);
          }
        },
      ),
    );
  }
}
