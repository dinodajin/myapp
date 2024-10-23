import 'dart:convert';
import 'dart:ffi';

import 'package:myapp/restaurant_json.dart';
import 'package:myapp/restaurant_list.dart';

class Restaurant {
  String name;
  String desc;
  String category;
  double? rating;
  Restaurant(this.name, this.desc, this.category, this.rating);
}

Future<List<Restaurant>> makeRestaurants() async {
  final json = jsonDecode(jsonString);
  List<Map<String, dynamic>> jsonList = List<Map<String, dynamic>>.from(
    json,
  );

  List<Restaurant> restaurants = [];

  for (var map in jsonList) {
    // map: Restaurant 정보가 담겨있는, Restaurant 객체를 만들기 위한 재료가 담겨있다.
    final Restaurant restaurant = Restaurant(
      map["name"],
      map["description"],
      map["category"],
      map["rating"],
    );
    restaurants.add(restaurant);
  }

  return restaurants;
}
