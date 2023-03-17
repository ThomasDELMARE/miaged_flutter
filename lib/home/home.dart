import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vinted_miage/clothes/clothes_list.dart';
import 'package:vinted_miage/services/firestore.dart';
import 'package:vinted_miage/users/user.dart';

import '../clothes/cart.dart';
import '../users/profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.displayMedium!,
        textAlign: TextAlign.center,
        child: FutureBuilder<User>(
            future: Firestore.getConnectedUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                    "Something went wrong when calling the getConnectedUser function");
              }
              if (!(snapshot.hasData && snapshot.data != null)) {
                return Scaffold(
                    body: Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                  color: const Color.fromARGB(181, 17, 229, 236),
                  size: 200,
                )));
              }
              if (snapshot.connectionState == ConnectionState.done) {
                User connectedUser = snapshot.data!;

                final List<Widget> widgetOptions = <Widget>[
                  ClothesListPage(connectedUser: connectedUser),
                  CartPage(connectedUser: connectedUser),
                  ProfilePage(connectedUser: connectedUser)
                ];

                return Scaffold(
                  body: Center(
                    child: widgetOptions.elementAt(_selectedIndex),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Acheter',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_basket_outlined),
                        label: 'Panier',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle),
                        label: 'Profil',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.white,
                    backgroundColor: const Color.fromARGB(181, 17, 229, 236),
                    onTap: _onItemTapped,
                  ),
                );
              }

              return Scaffold(
                  body: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                color: const Color.fromARGB(181, 17, 229, 236),
                size: 200,
              )));
            }));
  }
}
