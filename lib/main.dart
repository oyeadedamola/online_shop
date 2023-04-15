import 'package:flutter/material.dart';
import 'package:online_shop/helpers/custom_route.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/products_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import 'screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products('', '', []),
            update: (context, auth, previousProducts) => Products(
                auth.token ?? '',
                auth.userId ?? '',
                previousProducts!.items == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders('', '', []),
            update: (ctx, auth, previousOrder) => Orders(
                auth.token!,
                auth.userId!,
                previousOrder!.orders == null ? [] : previousOrder.orders),
          ),
        ],
        // value: Products(),
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.green,
                accentColor: Colors.yellowAccent,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder() ,
                  TargetPlatform.iOS: CustomPageTransitionBuilder()
                })
              ),
              home: auth.isAuth
                  ? ProductOverviewScreen(): 
                   FutureBuilder(
                      future: auth.autoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (context) =>
                    ProductDetailScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrdersScreen.routeName: (context) => OrdersScreen(),
                UsersProduct.routeName: (context) => UsersProduct(),
                EditProductScreen.routeName: (context) => EditProductScreen(),
              }),
        ));
  }
}
