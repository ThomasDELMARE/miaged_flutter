import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinted_miage/services/route_handler.gr.dart';

class AuthService extends AutoRouteGuard {
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool connectedValue = prefs.getBool('connected') ?? false;
      return Future.value(connectedValue);
    } on Exception catch (e) {
      print("Exception is : $e");
      return Future.value(false);
    }
  }

  Future<void> connect() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('connected', true);
  }

  Future<void> disconnect() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool('connected', false);
  }

  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    bool temp = await isAuthenticated();

    if (temp == true) {
      resolver.next(true);
    } else {
      router.push(const LoginRoute());
    }
  }
}
