library recipe_book_component;

import 'package:angular/angular.dart';
import 'package:tutorial/tooltip/tooltip.dart' show TooltipModel;
import 'package:tutorial/recipe.dart';

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
  static const String ERROR_MESSAGE = "Sorry! The cook stepped out of the "
      "kitchen and took the recipe book with him!";

  final Http _http;

  // Determine the initial load state of the app
  String message = LOADING_MESSAGE;
  bool recipesLoaded = false;
  bool categoriesLoaded = false;

  // Data objects that are loaded from the server side via json
  List<Recipe> recipes = [];

  // Filter box
  final categoryFilterMap = <String, bool>{};
  Iterable<String> get categories => categoryFilterMap.keys;
  String nameFilterString = "";

  Recipe selectedRecipe;

  RecipeBookComponent(this._http) {
    _loadData();
  }

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

  void clearFilters() {
    categoryFilterMap.clear();
    nameFilterString = "";
  }

  void _loadData() {
    recipesLoaded = false;
    categoriesLoaded = false;
    _http.get('recipes.json')
      .then((HttpResponse response) {
        print(response);
        recipes = response.data.map((d) => new Recipe.fromJson(d)).toList();
        recipesLoaded = true;
      })
      .catchError((e) {
        print(e);
        recipesLoaded = false;
        message = ERROR_MESSAGE;
      });

    _http.get('categories.json')
      .then((HttpResponse response) {
        print(response);
        for (String category in response.data) {
          categoryFilterMap[category] = false;
        }
        categoriesLoaded = true;
      })
      .catchError((e) {
        print(e);
        categoriesLoaded = false;
        message = ERROR_MESSAGE;
      });
  }
}
