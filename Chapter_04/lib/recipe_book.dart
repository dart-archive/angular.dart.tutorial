library recipe_book_controller;

import 'package:angular/angular.dart';

import 'tooltip/tooltip_directive.dart';

@NgController(
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

  // Tooltip
  static final tooltip = new Expando<TooltipModel>();
  TooltipModel tooltipForRecipe(Recipe recipe) {
    if (tooltip[recipe] == null) {
      tooltip[recipe] = new TooltipModel(recipe.imgUrl,
          "I don't have a picture of these recipes, "
          "so here's one of my cat instead!",
          80);
    }
    return tooltip[recipe]; // recipe.tooltip
  }

  List<Recipe> _loadData() {
    return [
      new Recipe('My Appetizer','Appetizers',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 1, 'fonzie1.jpg'),
      new Recipe('My Salad','Salads',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 3, 'fonzie2.jpg'),
      new Recipe('My Soup','Soups',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 4, 'fonzie1.jpg'),
      new Recipe('My Main Dish','Main Dishes',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 2, 'fonzie2.jpg'),
      new Recipe('My Side Dish','Side Dishes',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 3, 'fonzie1.jpg'),
      new Recipe('My Awesome Dessert','Desserts',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 5, 'fonzie2.jpg'),
      new Recipe('My So-So Dessert','Desserts',
          ["Ingredient 1", "Ingredient 2"],
          "Some Directions", 3, 'fonzie1.jpg'),
    ];
  }
}

class Recipe {
  String name;
  String category;
  List<String> ingredients;
  String directions;
  int rating;
  String imgUrl;

  Recipe(this.name, this.category, this.ingredients, this.directions,
      this.rating, this.imgUrl);
}
