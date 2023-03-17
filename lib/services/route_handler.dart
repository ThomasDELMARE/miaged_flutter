import 'package:auto_route/annotations.dart';
import 'package:vinted_miage/clothes/cart.dart';
import 'package:vinted_miage/users/profile.dart';
import '../home/home.dart';
import '../main.dart';
import 'guards/auth_service.dart';
import 'guards/connected_guard.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
        path: "/login",
        page: LoginPage,
        guards: [ConnectedGuard],
        initial: true),
    AutoRoute(path: "/home", page: HomePage, guards: [
      AuthService
    ], children: [
      AutoRoute(path: 'cart', page: CartPage),
      AutoRoute(path: 'settings', page: ProfilePage)
    ])
  ],
)
class $RouterHandler {}
