import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vinted_miage/users/user.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinted_miage/services/guards/connected_guard.dart';
import 'package:vinted_miage/services/route_handler.gr.dart';
import 'services/guards/auth_service.dart';

final _appRouter =
    RouterHandler(authService: AuthService(), connectedGuard: ConnectedGuard());

void main() async {
  // On regarde si l'on est connecté (on récuperera les données utilisateur plus tard)
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await prefs.setBool('connected', false);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        // On bind notre routeur personnalisé qui nous empêchera d'accéder à certaines pages
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser());
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _login, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(181, 17, 229, 236),
        title: const Text("Page de connexion"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Center(
                child: SizedBox(
                    width: 300,
                    height: 300,
                    child: Image.asset('../assets/images/miage.png')),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              SizedBox(
                  width: 1500,
                  child: TextFormField(
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
                  )),
              const Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                  width: 1500,
                  child: TextFormField(
                    validator: (input) {
                      if (input!.isEmpty) {
                        return 'Veuillez préciser un password';
                      }
                      return null;
                    },
                    onSaved: (input) => _password = input!,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  )),
              const Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: const Color.fromARGB(181, 17, 229, 236),
                  ),
                  onPressed: () {
                    signIn();
                  },
                  child: const Text('Se connecter'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final db = FirebaseFirestore.instance;
      final usersCollection = db.collection("users");

      // On vérifie l'utilisateur avec le combo mail/password
      final query = usersCollection
          .where("login", isEqualTo: _login)
          .where("password", isEqualTo: _password);

      query.get().then(
        (result) async {
          var requestResult = result.docs;

          if (result.docs.isNotEmpty) {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            // On parse le renvoi de Firebase en user
            User foundUser = requestResult
                .map((item) => User.fromFirestore(item))
                .toList()[0];

            // On le parse pour qu'il soit sauvegardé par le sharedPreferences et utilisé plus tard
            Map<String, dynamic> userData = {
              'id': foundUser.id.toString(),
              'login': foundUser.login.toString(),
              'password': foundUser.password.toString(),
              'anniversaire': foundUser.anniversaire.toString(),
              'adresse': foundUser.adresse.toString(),
              'cp': foundUser.cp.toString(),
              'ville': foundUser.ville.toString(),
              'panier': foundUser.panier
            };

            await prefs.setString('userData', jsonEncode(userData));
            await AuthService().connect();

            // Permet de placer l'utilisateur sur la bonne page
            context.router.navigateNamed('/');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      "Aucun utilisateur n'a été trouvé avec ces informations")),
            );
          }
        },
        onError: (e) => print("Erreur pendant la query : $e"),
      );
    }
  }
}
