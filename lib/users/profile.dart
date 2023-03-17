import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vinted_miage/services/firestore.dart';
import 'package:vinted_miage/services/guards/auth_service.dart';
import 'package:vinted_miage/users/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.connectedUser});
  final User connectedUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePageWidget(connectedUser: connectedUser),
    );
  }
}

class ProfilePageWidget extends StatefulWidget {
  ProfilePageWidget({super.key, required this.connectedUser});
  late User connectedUser;

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  final _formKey = GlobalKey<FormState>();
  late String _login, _password, _adresse, _codePostal, _ville, _anniversaire;

  late TextEditingController dateController = TextEditingController(
      text: widget.connectedUser.anniversaireUser.toString());

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.displayMedium!,
        textAlign: TextAlign.center,
        child: FutureBuilder<User>(
            future: Firestore.getUserById(widget.connectedUser.idUser),
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
                User retrievedUser = snapshot.data!;

                return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    backgroundColor: const Color.fromARGB(181, 17, 229, 236),
                    title: const Text("Mon profil"),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(181, 17, 229, 236),
                        ),
                        onPressed: () async {
                          String result =
                              await sauvegarderProfil(retrievedUser);

                          if (result == "success") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Le profil a bien été mis à jour !'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Une erreur est survenue, le profil n'
                                        'a pas été mis à jour !'),
                              ),
                            );
                          }
                        },
                        child: const Text('Valider'),
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const Padding(padding: EdgeInsets.all(10)),
                          Center(
                              child: SizedBox(
                                  width: 1500,
                                  child: TextFormField(
                                    initialValue:
                                        retrievedUser.loginUser.toString(),
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Veuillez préciser un login';
                                      }
                                      return null;
                                    },
                                    onSaved: (input) => _login = input!,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Login',
                                    ),
                                  ))),
                          const Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                              width: 1500,
                              child: Center(
                                  child: TextFormField(
                                obscureText: true,
                                initialValue: retrievedUser.passwordUser,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'Veuillez préciser un password';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _password = input!,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                ),
                              ))),
                          const Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                              width: 1500,
                              child: Center(
                                  child: TextFormField(
                                controller: dateController,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'Veuillez préciser un anniversaire';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _anniversaire = input!,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);

                                    dateController.text = formattedDate;
                                    setState(() {
                                      dateController.text = formattedDate;
                                    });
                                  } else {}
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Anniversaire',
                                ),
                              ))),
                          const Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                              width: 1500,
                              child: Center(
                                  child: TextFormField(
                                initialValue: retrievedUser.adresseUser,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'Veuillez préciser une adresse';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _adresse = input!,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Adresse',
                                ),
                              ))),
                          const Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                              width: 1500,
                              child: Center(
                                  child: TextFormField(
                                initialValue: retrievedUser.cpUser,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'Veuillez préciser un code postal';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _codePostal = input!,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Code postal',
                                ),
                              ))),
                          const Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                              width: 1500,
                              child: Center(
                                  child: TextFormField(
                                initialValue: retrievedUser.villeUser,
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'Veuillez préciser une ville';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _ville = input!,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Ville',
                                ),
                              ))),
                          const Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                              width: 150,
                              height: 50,
                              child: Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.all(20),
                                      textStyle: const TextStyle(fontSize: 15)),
                                  onPressed: () {
                                    seDeconnecter();
                                  },
                                  child: const Text('Se déconnecter'),
                                ),
                              ))
                        ],
                      ),
                    ),
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

  void seDeconnecter() {
    AuthService().disconnect();
    context.router.navigateNamed('/login');
  }

  Future<String> sauvegarderProfil(User userToUpdate) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // On recrée l'utilisateur en entier
        final db = FirebaseFirestore.instance;
        DateTime finalDate = DateTime.parse(_anniversaire);

        // Update user cart
        await db.collection("users").doc(userToUpdate.id).update({
          'login': _login,
          'password': _password,
          'adresse': _adresse,
          'cp': _codePostal,
          'ville': _ville,
          'anniversaire': finalDate
        });

        return "success";
      } on Exception catch (e) {
        print("Exception is : $e");
        return "failed";
      }
    }

    return "failed";
  }
}
