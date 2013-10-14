import 'package:angular/angular.dart';
import 'package:di/di.dart';

@NgDirective(
    selector: '[recipe-book]',
    publishAs: 'ctrl')
class RecipeBookController {

  List recipes;

  RecipeBookController() {
    recipes = _loadData();
  }

  Recipe selectedRecipe;

  void selectRecipe(Recipe recipe) {
    selectedRecipe = recipe;
  }

  List<Recipe> _loadData() {
    return [
      new Recipe('My Appetizer','Appetizers',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 1),
      new Recipe('My Salad','Salads',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 3),
      new Recipe('My Soup','Soups',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 4),
      new Recipe('My Main Dish','Main Dishes',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 2),
      new Recipe('My Side Dish','Side Dishes',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 3),
      new Recipe('My Awesome Dessert','Desserts',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 5),
      new Recipe('My So-So Dessert','Desserts',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 3),
      ];
  }
}

@NgComponent(
    selector: 'rating',
    templateUrl: 'rating_component.html',
    cssUrl: 'rating_component.css',
    publishAs: 'ctrl',
    map: const {
      'max': '@.max'
    }
)
class RatingComponent {
  final NgModel ngModel;

  String _starOnChar = "\u2605";
  String _starOffChar = "\u2606";
  String _starOnClass = "star-on";
  String _starOffClass = "star-off";

  List<int> stars = [];

  get rating => ngModel.viewValue;
  set rating(value) => ngModel.viewValue = value;

  set max(String value) {
    stars = [];
    var count = int.parse(value);
    for(var i=1; i <= count; i++) {
      stars.add(i);
    }
  }

  RatingComponent(NgModel this.ngModel);

  String starClass(int star) {
    return star > rating ? _starOffClass : _starOnClass;
  }

  String starChar(int star) {
    return star > rating ? _starOffChar : _starOnChar;
  }

  void clickStar(int star) {
    if (star == 1 && rating == 1) {
      rating = 0;
    } else {
      rating = star;
    }
  }
}

class Recipe {
  String name;
  String category;
  List<String> ingredients;
  String directions;
  int rating;

  Recipe(this.name, this.category, this.ingredients, this.directions,
      this.rating);
}

main() {
  var module = new AngularModule()
    ..type(RecipeBookController)
    ..type(RatingComponent);

  bootstrapAngular([module]);
}