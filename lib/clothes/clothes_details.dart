import 'package:flutter/material.dart';
import 'package:vinted_miage/users/user.dart';

import '../services/firestore.dart';
import 'clothe.dart';

class ClothesDetails extends StatelessWidget {
  const ClothesDetails(
      {super.key, required this.selectedClothe, required this.connectedUser});

  final Clothe selectedClothe;
  final User connectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(181, 17, 229, 236),
        title:
            Text("Détails du vêtement : ${selectedClothe.marque.toString()}"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            Center(
                child: SizedBox(
                    width: 500,
                    height: 400,
                    child: Image.network(selectedClothe.image.toString()))),
            Center(
                child: SizedBox(
                    child: Text(selectedClothe.titre.toString(),
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline)))),
            Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Taille :',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                              text: " ${selectedClothe.taille.toString()}",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black)),
                        ],
                      ),
                    ))),
            Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Marque :',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                              text: " ${selectedClothe.marque.toString()}",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black)),
                        ],
                      ),
                    ))),
            Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 20),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Prix :',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                              text: " ${selectedClothe.prix.toString()} €",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black)),
                        ],
                      ),
                    ))),
            Center(
                child: SizedBox(
              width: 300,
              height: 75,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(181, 17, 229, 236),
                    padding: const EdgeInsets.all(20),
                    textStyle: const TextStyle(fontSize: 25)),
                onPressed: () async {
                  String result =
                      await Firestore.addToCart(connectedUser, selectedClothe);
                  if (result == "doublon") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Le vêtement est déjà dans votre panier")),
                    );
                  } else if (result == "success") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Le vêtement a bien été ajouté au panier")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("La requête a échoué")),
                    );
                  }
                },
                child: const Text('Ajouter au panier'),
              ),
            ))
          ])),
    );
  }
}
