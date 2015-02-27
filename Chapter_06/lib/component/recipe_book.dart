library recipe_book_component;

import 'package:angular/angular.dart';
import 'package:tutorial/tooltip/tooltip.dart' show TooltipModel;
import 'package:tutorial/service/recipe.dart';
import 'package:tutorial/service/query.dart';

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

  static const String LOADING_MESSAGE = "Loading recipe book...";
  static const String ERROR_MESSAGE = "Sorry! The cook stepped out of the"
      "kitchen and took the recipe book with him!";

  final Http _http;
  final QueryService queryService;

  // Determine the initial load state of the app
  String message = LOADING_MESSAGE;
  bool recipesLoaded = false;
  bool categoriesLoaded = false;

  Map<String, Recipe> _recipeMap = {};
  Map<String, Recipe> get recipeMap => _recipeMap;

  List<Recipe> _allRecipes = [];

  List<Recipe> get allRecipes => _allRecipes;

  // Filter box
  final Map<String, bool> categoryFilterMap = {};
  final List<String> categories = [];
  String nameFilter = "";

  RecipeBookComponent(this._http, this.queryService) {
    _loadData();
  }

  Recipe selectedRecipe;

  void selectRecipe(Recipe recipe) {
    selectedRecipe = recipe;
  }

  // Tooltip
  static final _tooltip = new Expando<TooltipModel>();
  TooltipModel tooltipForRecipe(Recipe recipe) {
    if (_tooltip[recipe] == null) {
      _tooltip[recipe] = new TooltipModel(recipe.imgUrl,
          "I don't have a picture of these recipes, "
          "so here's one of my cat instead!",
          80);
    }
    return _tooltip[recipe]; // recipe.tooltip
  }

  void _loadData() {
    queryService.getAllRecipes()
      .then((Map<String, Recipe> allRecipes) {
        _recipeMap = allRecipes;
        _allRecipes = _recipeMap.values.toList();
        recipesLoaded = true;
      })
      .catchError((e) {
        print(e);
        recipesLoaded = false;
        message = ERROR_MESSAGE;
      });

    queryService.getAllCategories()
      .then((List<String> allCategories) {
        for (String category in allCategories) {
          categoryFilterMap[category] = false;
        }
        categories.addAll(categoryFilterMap.keys);
        categoriesLoaded = true;
      })
      .catchError((e) {
        print(e);
        categoriesLoaded = false;
        message = ERROR_MESSAGE;
      });
  }
}
