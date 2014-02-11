library recipe_book;

import 'package:angular/angular.dart';

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(targets: const['recipe_book'], override: '*')
import 'dart:mirrors';

/* Use the @NgController annotation to indicate that this class is an
 * Angular controller. Angular will instantiate the controller if
 * it finds an element matching its selector in the DOM.
 *
 * The selector field defines the CSS selector that will trigger the
 * controller. It can be any valid CSS selector which does not cross
 * element boundaries.
 *
 * The publishAs field specifies that the controller instance should be
 * assigned to the current scope under the name specified.
 *
 * The controller's public fields are available for data binding from the view.
 * Similarly, the controller's public methods can be invoked from the view.
 */
@NgController(
    selector: '[recipe-book]',
    publishAs: 'ctrl')
class RecipeBookController {

  List<Recipe> recipes;
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

class Recipe {
  String name;
  String category;
  List<String> ingredients;
  String directions;
  int rating;

  Recipe(this.name, this.category, this.ingredients, this.directions,
      this.rating);
}

class MyAppModule extends Module {
  MyAppModule() {
    type(RecipeBookController);
  }
}

void main() {
  ngBootstrap(module: new MyAppModule());
}
