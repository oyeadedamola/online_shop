import 'package:flutter/material.dart';
import 'package:online_shop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UsersProduct extends StatelessWidget {
  const UsersProduct({super.key});

  static const routeName = '/userproducts';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            }, icon: const Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting ?
        Center(
          child: CircularProgressIndicator(),
        )
        : RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Consumer<Products>(
          builder: (ctx, productsData, _) => Padding(
            padding:EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: (_, i) =>UsersProductItem(
                productsData.items[i].id!,
                productsData.items[i].title,
                productsData.items[i].imageUrl,
              ),
              itemCount: productsData.items.length ),
              ),
        ),
      )
    )
    );
  }
}