import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'products_item.dart';
import '../providers/products_provider.dart';


class ProductsGrid extends StatelessWidget {
   final bool showFavs;

   ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData =Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        // create: (context) => products[index],
        value: products[index],
        child: ProductItem(
        // products[index].id,
        // products[index].title,
        // products[index].imageUrl,
      ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}