import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? adresse;
  DateTime? anniversaire;
  String? cp;
  String? login;
  String? password;
  List<dynamic>? panier;
  String? ville;

  User(
      {this.id,
      this.adresse,
      this.anniversaire,
      this.login,
      this.password,
      this.cp,
      this.panier,
      this.ville});

  String? get idUser {
    return id;
  }

  String? get adresseUser {
    return adresse;
  }

  String? get cpUser {
    return cp;
  }

  String? get loginUser {
    return login;
  }

  String? get passwordUser {
    return password;
  }

  DateTime? get anniversaireUser {
    return anniversaire;
  }

  List? get panierUser {
    return panier;
  }

  String? get villeUser {
    return ville;
  }

  set villeUserSet(String newVille) {
    ville = newVille;
  }

  set idUserUserSet(String newidUser) {
    id = newidUser;
  }

  set adresseUserSet(String newAdresse) {
    adresse = newAdresse;
  }

  set panierUserSet(List<String?>? newPanier) {
    panier = newPanier;
  }

  set anniversaireUserSet(DateTime newAnniversaire) {
    anniversaire = newAnniversaire;
  }

  set loginUserSet(String newLogin) {
    login = newLogin;
  }

  set passwordUserSet(String newPassword) {
    password = newPassword;
  }

  set cpUserSet(String newCp) {
    cp = newCp;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json['anniversaire'].toString());

    return User(
        id: json["id"],
        adresse: json["adresse"],
        anniversaire: date,
        login: json["login"],
        password: json["password"],
        cp: json["cp"],
        panier: json["panier"],
        ville: json["ville"]);
  }

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return User(
      id: snapshot.reference.id.toString(),
      adresse: data?['adresse'],
      anniversaire: data?['anniversaire'].toDate(),
      cp: data?['cp'],
      panier: data?['panier'],
      ville: data?['ville'],
      login: data?['login'],
      password: data?['password'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (adresse != null) "adresse": adresse,
      if (anniversaire != null) "anniversaire": anniversaire,
      if (cp != null) "cp": cp,
      if (panier != null) "panier": panier,
      if (ville != null) "ville": ville,
      if (login != null) "login": login,
      if (password != null) "password": password,
    };
  }
}
