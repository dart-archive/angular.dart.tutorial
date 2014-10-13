library recipe_book_component;

import 'package:angular/angular.dart';

/* The selector field defines the CSS selector that will trigger the component. It can be any valid
 * CSS selector which does not cross element boundaries.
 *
 * The component's public fields are available for data binding from the view.
 * Similarly, the component's public methods can be invoked from the view.
 */
@Component(
    selector: 'recipe-book',
    templateUrl: 'recipe_book.html')
class RecipeBookComponent {
  Recipe selectedRecipe;
  List<Recipe> recipes;

  RecipeBookComponent() {
    recipes = _loadData();
  }

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
  final String name;
  final String category;
  final List<String> ingredients;
  final String directions;
  int rating;

  Recipe(this.name, this.category, this.ingredients, this.directions, this.rating);
}
