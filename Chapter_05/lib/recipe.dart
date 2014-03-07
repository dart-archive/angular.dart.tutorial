library recipe;

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

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": id,
    "name": name,
    "category": category,
    "ingredients": ingredients,
    "directions": directions,
    "rating": rating,
    "imgUrl": imgUrl
  };

  factory Recipe.fromJsonMap(Map<String, dynamic> json) => new Recipe(json['id'], json['name'],
      json['category'], json['ingredients'], json['directions'], json['rating'],
      json['imgUrl']);
}
