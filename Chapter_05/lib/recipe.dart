library recipe;

class Recipe {
  String id;
  String name;
  String category;
  List<String> ingredients;
  String directions;
  String imgUrl;
  int rating;

  Recipe(this.id, this.name, this.category, this.ingredients, this.directions, this.rating,
         this.imgUrl);

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": id,
    "name": name,
    "category": category,
    "ingredients": ingredients,
    "directions": directions,
    "rating": rating,
    "imgUrl": imgUrl
  };

  Recipe.fromJson(Map<String, dynamic> json): this(json['id'], json['name'], json['category'],
      json['ingredients'], json['directions'], json['rating'], json['imgUrl']);
}
