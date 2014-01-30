library recipe;

import 'dart:convert';

class Recipe {
  String id;
  String name;
  String category;
  List<String> ingredients;
  String directions;
  int rating;
  String imgUrl;

  Recipe(this.id, this.name, this.category, this.ingredients, this.directions,
      this.rating, this.imgUrl);

  String toJsonString() {
    Map data = {
                "id" : id,
                "name" : name,
                "category" : category,
                "ingredients" : ingredients,
                "directions" : directions,
                "rating" : rating,
                "imgUrl" : imgUrl
    };
    return JSON.encode(data);
  }

  factory Recipe.fromJsonMap(Map json) {
    return new Recipe(json['id'], json['name'], json['category'],
        json['ingredients'], json['directions'], json['rating'],
        json['imgUrl']);
  }
}
