import 'package:auto_route/auto_route.dart';
import 'package:vinted_miage/services/guards/auth_service.dart';
import 'package:vinted_miage/services/route_handler.gr.dart';

class ConnectedGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    bool temp = await AuthService().isAuthenticated();

    if (temp == true) {
      router.push(const HomeRoute());
    } else {
      resolver.next(true);
    }
  }
}
