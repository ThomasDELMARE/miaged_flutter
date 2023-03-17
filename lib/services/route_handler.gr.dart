// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../clothes/cart.dart' as _i3;
import '../home/home.dart' as _i2;
import '../main.dart' as _i1;
import '../users/profile.dart' as _i4;
import '../users/user.dart' as _i9;
import 'guards/auth_service.dart' as _i8;
import 'guards/connected_guard.dart' as _i7;

class RouterHandler extends _i5.RootStackRouter {
  RouterHandler({
    _i6.GlobalKey<_i6.NavigatorState>? navigatorKey,
    required this.connectedGuard,
    required this.authService,
  }) : super(navigatorKey);

  final _i7.ConnectedGuard connectedGuard;

  final _i8.AuthService authService;

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.LoginPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    CartRoute.name: (routeData) {
      final args = routeData.argsAs<CartRouteArgs>();
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.CartPage(
          key: args.key,
          connectedUser: args.connectedUser,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteArgs>();
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.ProfilePage(
          key: args.key,
          connectedUser: args.connectedUser,
        ),
      );
    },
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/login',
          fullMatch: true,
        ),
        _i5.RouteConfig(
          LoginRoute.name,
          path: '/login',
          guards: [connectedGuard],
        ),
        _i5.RouteConfig(
          HomeRoute.name,
          path: '/home',
          guards: [authService],
          children: [
            _i5.RouteConfig(
              CartRoute.name,
              path: 'cart',
              parent: HomeRoute.name,
            ),
            _i5.RouteConfig(
              ProfileRoute.name,
              path: 'settings',
              parent: HomeRoute.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.LoginPage]
class LoginRoute extends _i5.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          path: '/home',
          initialChildren: children,
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.CartPage]
class CartRoute extends _i5.PageRouteInfo<CartRouteArgs> {
  CartRoute({
    _i6.Key? key,
    required _i9.User connectedUser,
  }) : super(
          CartRoute.name,
          path: 'cart',
          args: CartRouteArgs(
            key: key,
            connectedUser: connectedUser,
          ),
        );

  static const String name = 'CartRoute';
}

class CartRouteArgs {
  const CartRouteArgs({
    this.key,
    required this.connectedUser,
  });

  final _i6.Key? key;

  final _i9.User connectedUser;

  @override
  String toString() {
    return 'CartRouteArgs{key: $key, connectedUser: $connectedUser}';
  }
}

/// generated route for
/// [_i4.ProfilePage]
class ProfileRoute extends _i5.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    _i6.Key? key,
    required _i9.User connectedUser,
  }) : super(
          ProfileRoute.name,
          path: 'settings',
          args: ProfileRouteArgs(
            key: key,
            connectedUser: connectedUser,
          ),
        );

  static const String name = 'ProfileRoute';
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    required this.connectedUser,
  });

  final _i6.Key? key;

  final _i9.User connectedUser;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, connectedUser: $connectedUser}';
  }
}
