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

@NgController(
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
  String nameFilterString = "";

  RecipeBookController(Http this._http) {
    _loadData();
  }

  Recipe selectedRecipe;

  void selectRecipe(Recipe recipe) {
    selectedRecipe = recipe;
  }

  void clearFilters() {
    categoryFilterMap.keys.forEach((f) => categoryFilterMap[f] = false);
    nameFilterString = "";
  }

  void _loadData() {
    recipesLoaded = false;
    categoriesLoaded = false;
    _http.get('recipes.json')
      .then((HttpResponse response) {
      print(response);
        for (Map recipe in response.data) {
          recipes.add(new Recipe.fromJsonMap(recipe));
        }
        recipesLoaded = true;
      },
      onError: (Object obj) {
        print(obj);
        recipesLoaded = false;
        message = ERROR_MESSAGE;
      });

    _http.get('categories.json')
        .then((HttpResponse response) {
      print(response);
      for (String category in response.data) {
        categories.add(category);
        categoryFilterMap[category] = false;
      }
      categoriesLoaded = true;
    },
    onError: (Object obj) {
      print(obj);
      categoriesLoaded = false;
      message = ERROR_MESSAGE;
    });
  }
}

class MyAppModule extends Module {
  MyAppModule() {
    type(RecipeBookController);
    type(RatingComponent);
    type(CategoryFilter);
    type(Profiler, implementedBy: Profiler); // comment out to enable profiling
  }
}

main() {
  ngBootstrap(module: new MyAppModule());
}

