import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vinted_miage/users/user.dart';
import '../services/firestore.dart';
import 'clothe.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.connectedUser});
  final User connectedUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CartPageWidget(connectedUser: connectedUser),
    );
  }
}

class CartPageWidget extends StatefulWidget {
  const CartPageWidget({super.key, required this.connectedUser});
  final User connectedUser;

  @override
  State<CartPageWidget> createState() => _CartPageWidgetState();
}

class _CartPageWidgetState extends State<CartPageWidget> {
  _CartPageWidgetState();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.displayMedium!,
        textAlign: TextAlign.center,
        child: FutureBuilder<List<Clothe>>(
            future: Firestore.getUserCart(widget.connectedUser.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                    "Something went wrong when calling the getUserCart function");
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
                List<Clothe> clothesList = snapshot.data!;
                int shoppingTotal = 0;

                for (var element in clothesList) {
                  shoppingTotal += element.prix!;
                }

                return Scaffold(
                    appBar: AppBar(
                      backgroundColor: const Color.fromARGB(181, 17, 229, 236),
                      title: const Text("Panier"),
                      centerTitle: true,
                    ),
                    body: Column(children: [
                      const Padding(padding: EdgeInsets.all(20)),
                      ListView.builder(
                        itemCount: clothesList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: ListTile(
                                leading: Image.network(
                                  clothesList[index].image.toString(),
                                ),
                                title: Text(
                                    '${clothesList[index].titre} - ${clothesList[index].taille}'),
                                subtitle:
                                    Text(clothesList[index].marque.toString()),
                                trailing: Column(
                                  children: <Widget>[
                                    SizedBox(
                                        height: 30,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: Text(
                                                'Supprimer : ${clothesList[index].prix.toString()} €'),
                                            onPressed: () async {
                                              await deleteItem(
                                                  widget.connectedUser,
                                                  clothesList[index].id);
                                              setState(() {});
                                            }))
                                  ],
                                )),
                          );
                        },
                      ),
                      ListTile(
                          title: const Text("Total du panier :"),
                          trailing: Text("$shoppingTotal €",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))),
                    ]));
              }

              return Scaffold(
                  body: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 200,
              )));
            }));
  }
}

Future<String> deleteItem(User connectedUser, String? clotheId) async {
  return await Firestore.deleteClothe(connectedUser, clotheId);
}
