import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../clothes/clothe.dart';
import '../users/user.dart';

class Firestore {
  static Future<List<Clothe>> getAllClothes() async {
    return (await FirebaseFirestore.instance.collection("clothes").get())
        .docs
        .map((item) => Clothe.fromFirestore(item))
        .toList();
  }

  static Future<User> getConnectedUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var fetchedUser = prefs.getString('userData');
      Map<String, dynamic> jsonUser = jsonDecode(fetchedUser!);
      User finalUser = User.fromJson(jsonUser);

      return finalUser;
    } catch (e) {
      print(e);
      return User();
    }
  }

  static Future<String> addToCart(
      User connectedUser, Clothe clotheToAdd) async {
    // On le récupère en BDD pour pouvoir avoir un panier à jour
    connectedUser = await getUserById(connectedUser.id!);

    if (connectedUser.panierUser != null &&
        connectedUser.panierUser!.contains(clotheToAdd.id)) {
      return "doublon";
    } else {
      if (connectedUser.panierUser == null) {
        List<String?> growableList = [];
        growableList.add(clotheToAdd.id);
        connectedUser.panierUserSet = growableList;
      } else {
        connectedUser.panierUser!.add(clotheToAdd.id);
      }

      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(connectedUser.id)
            .update({"panier": connectedUser.panierUser!});

        return "success";
      } on Exception catch (e) {
        print('Request failed $e}');
        return "failed";
      }
    }
  }

  static Future<List<Clothe>> getUserCart(String? userId) async {
    try {
      List<Clothe> clothesList = [];

      User userCart = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get()
          .then((value) async {
        User foundUser = User.fromFirestore(value);
        return foundUser;
      });

      for (var i = 0; i < userCart.panierUser!.length; i++) {
        var clothe = await FirebaseFirestore.instance
            .collection("clothes")
            .doc(userCart.panierUser?[i])
            .get()
            .then((value) async {
          var clothe = Clothe.fromFirestore(value);
          return clothe;
        });

        clothesList.add(clothe);
      }

      return clothesList;
    } on Exception catch (e) {
      print("Exception is : $e");
      return List.empty();
    }
  }

  static Future<String> deleteClothe(
      User connectedUser, String? clotheId) async {
    connectedUser = await getUserById(connectedUser.id!);
    try {
      connectedUser.panierUser?.removeWhere((item) => item == clotheId);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(connectedUser.id)
          .update({'panier': connectedUser.panierUser}).then((value) async {
        return "success";
      });

      return "success";
    } on Exception catch (e) {
      print("Exception is : $e");
      return "failed";
    }
  }

  static Future<User> getUserById(String? userId) async {
    try {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get()
          .then((value) async {
        return User.fromFirestore(value);
      });
    } on Exception catch (e) {
      print("Exception is : $e");
    }
    return User();
  }
}
