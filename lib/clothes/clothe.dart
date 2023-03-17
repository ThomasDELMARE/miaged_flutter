import 'package:cloud_firestore/cloud_firestore.dart';

class Clothe {
  final String? id;
  final String? image;
  final String? marque;
  final int? prix;
  final String? taille;
  final String? titre;
  final String? type;

  Clothe(
      {this.id,
      this.image,
      this.marque,
      this.prix,
      this.taille,
      this.titre,
      this.type});

  factory Clothe.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return Clothe(
        id: snapshot.reference.id,
        image: data?['image'],
        marque: data?['marque'],
        prix: data?['prix'],
        taille: data?['taille'],
        titre: data?['titre'],
        type: data?['type']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (image != null) "image": image,
      if (marque != null) "marque": marque,
      if (prix != null) "prix": prix,
      if (taille != null) "taille": taille,
      if (titre != null) "titre": titre,
      if (type != null) "type": type,
    };
  }
}
