import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products_provider.dart';

class UsersProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UsersProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(onPressed: (){
               Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments:id );
            },
             icon: Icon(Icons.edit),
             color: Theme.of(context).primaryColor,),
             IconButton(onPressed: () async {
               try{
                 await Provider.of<Products>(context, listen: false).deleteProduct(id);
               } catch (error) {
                print(error);
                scaffold.hideCurrentSnackBar();
                scaffold.showSnackBar(
                  SnackBar(content: Text('Deleting failed!', textAlign: TextAlign.center,),
                  duration: Duration(seconds: 2),
                  ),
                );
               }
               
            },
             icon: Icon(Icons.delete),
             color: Theme.of(context).errorColor,)
          ],
        ),
      ),

    );
  }
}