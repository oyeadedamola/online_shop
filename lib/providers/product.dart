import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'auth.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description; 
  final double price;
  final String imageUrl;
  var isFavorite;

Product({
  required this.id,
  required this.title,
  required this.description,
  required this.price,
  required this.imageUrl,
  this.isFavorite =false,
});

//  toggleFavouritesStatus(){
//   isFavorite = !isFavorite;
//   notifyListeners();
//  }

Future<void> toggleFavouritesStatus(String token, String userId) async {
  final Oldstatus = isFavorite;
  isFavorite = !isFavorite;
  notifyListeners();

  final url = Uri.parse('https://flutter-shopping-6dbda-default-rtdb.europe-west1.firebasedatabase.app/userFavourites/$userId/$id.json?auth=$token');
  try {
   await http.put(url, body: json.encode(
    isFavorite,
  )
  );
  } catch (error){
    print(error);
   isFavorite = Oldstatus;
        notifyListeners();
  };
  
  
} 

}