library recipe_book_controller;

import 'package:angular/angular.dart';

import 'tooltip/tooltip_directive.dart';
import 'service/recipe.dart';
import 'service/query_service.dart';

@NgController(
    selector: '[recipe-book]',
    publishAs: 'ctrl')
class RecipeBookController {

  static const String LOADING_MESSAGE = "Loading recipe book...";
  static const String ERROR_MESSAGE = """Sorry! The cook stepped out of the 
kitchen and took the recipe book with him!""";

  Http _http;
  QueryService _queryService;
  QueryService get queryService => _queryService;

  // Determine the initial load state of the app
  String message = LOADING_MESSAGE;
  bool recipesLoaded = false;
  bool categoriesLoaded = false;

  // Data objects that are loaded from the server side via json
  List _categories = [];
  get categories => _categories;
  Map<String, Recipe> _recipeMap = {};
  get recipeMap => _recipeMap;
  get allRecipes => _recipeMap.values.toList();

  // Filter box
  Map<String, bool> categoryFilterMap = {};
  String nameFilter = "";

  RecipeBookController(Http this._http, QueryService this._queryService) {
    _loadData();
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

  void _loadData() {
    _queryService.getAllRecipes()
      .then((Map<String, Recipe> allRecipes) {
        _recipeMap = allRecipes;
        recipesLoaded = true;
      },
      onError: (Object obj) {
        recipesLoaded = false;
        message = ERROR_MESSAGE;
      });

    _queryService.getAllCategories()
      .then((List<String> allCategories) {
        _categories = allCategories;
        for (String category in _categories) {
          categoryFilterMap[category] = false;
        }
        categoriesLoaded = true;
      },
      onError: (Object obj) {
        categoriesLoaded = false;
        message = ERROR_MESSAGE;
      });
  }
}