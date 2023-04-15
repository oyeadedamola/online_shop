import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';
import '/screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';



enum FilterOptions {
  Favourites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  @override 
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts();
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      //  _isLoading = true;
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
            _isLoading = false;
        });
          // _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(appBar: AppBar(
      title: Text('Myshop'),
      actions: [
        PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: (FilterOptions selectedValue) {
          setState(() {
            if (selectedValue == FilterOptions.Favourites) {
            _showOnlyFavourites = true;
          } else {
            _showOnlyFavourites = false;
          }  
          });
          
          },
        itemBuilder: (_) =>[
          PopupMenuItem(child: Text('Only Favourites'), 
          value: FilterOptions.Favourites,),
          PopupMenuItem(child: Text('Show All'), 
          value: FilterOptions.All,)
        ],
        ),
        Consumer<Cart>(builder: (_,cart,ch) => BadgeNew(
          
              value: cart.itemCount.toString(),
              child: IconButton(
            icon: Icon(
              Icons.shopping_cart, 
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              ), 
              ),
    )
      ],
      ),
      drawer: AppDrawer(),
      body: _isLoading? Center(child: CircularProgressIndicator() ): ProductsGrid(
        
        _showOnlyFavourites
      ),

    );
  }
}

