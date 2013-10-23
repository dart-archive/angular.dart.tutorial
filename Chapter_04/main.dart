library recipe_book;

import 'package:angular/angular.dart';
import 'dart:convert';
import 'package:perf_api/perf_api.dart';
import 'package:di/di.dart';

part 'rating_component.dart';
part 'recipe.dart';


@NgFilter(name: 'categoryfilter')
class CategoryFilter {
  call(recipeList, filterMap) {
    if (recipeList is List && filterMap != null && filterMap is Map) {
      // If there is nothing checked, treat it as "everything is checked"
      bool nothingChecked = filterMap.values.every((isChecked) => !isChecked);
      if (nothingChecked) {
        return recipeList.toList();
      }
      return recipeList.where((i) => filterMap[i.category] == true).toList();
    }
  }
}

@NgDirective(
    selector: '[recipe-book]',
    publishAs: 'ctrl')
class RecipeBookController {

  static const String LOADING_MESSAGE = "Loading recipe book...";
  static const String ERROR_MESSAGE = """Sorry! The cook stepped out of the 
kitchen and took the recipe book with him!""";

  Http _http;

  // Determine the initial load state of the app
  String message = LOADING_MESSAGE;
  bool recipesLoaded = false;
  bool categoriesLoaded = false;

  // Data objects that are loaded from the server side via json
  List categories = [];
  List<Recipe> recipes = [];

  // Filter box
  Map<String, bool> categoryFilterMap = {};
  String nameFilter = "";

  RecipeBookController(Http this._http) {
    _loadData();
  }

  Recipe selectedRecipe;

  void selectRecipe(Recipe recipe) {
    selectedRecipe = recipe;
  }

  void clearFilters() {
    categoryFilterMap.keys.forEach((f) => categoryFilterMap[f] = false);
    nameFilter = "";
  }

  void _loadData() {
    recipesLoaded = false;
    categoriesLoaded = false;

    _http.get('/angular.dart.tutorial/Chapter_04/recipes.json')
      .then((HttpResponse response) {
        for (Map recipe in response.data) {
          recipes.add(new Recipe.fromJsonMap(recipe));
        }
        recipesLoaded = true;
      },
      onError: (Object obj) {
        recipesLoaded = false;
        message = ERROR_MESSAGE;
      });

    _http.get('/angular.dart.tutorial/Chapter_04/categories.json')
        .then((HttpResponse response) {
      for (String category in response.data) {
        categories.add(category);
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

// TODO - Remove the Profiler type. It's only needed to get rid of Misko's spam
main() {
  var module = new AngularModule()
    ..type(RecipeBookController)
    ..type(RatingComponent)
    ..type(CategoryFilter)
    ..type(Profiler, implementedBy: Profiler);

  ngBootstrap(module: module);
}
