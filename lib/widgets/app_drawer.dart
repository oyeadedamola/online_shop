import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column( children: [
        AppBar(
          title: Text('Hello Friend!'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
            // Navigator.of(context).pushReplacement(CustomRoute(builder: (context) => OrdersScreen(),));
          },
          ),
          Divider(),
          ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
          ),
          Divider(),
          ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Manage Products'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(UsersProduct.routeName);
          },
          
          ),
          Divider(),
          ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            // Navigator.of(context).pushReplacementNamed(UsersProduct.routeName);
            Provider.of<Auth>(context, listen: false).logout();
          },
          ),
         
      ],
      ),
    );
  }
}