library recipe_book;

import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';
import 'dart:async';
import 'dart:convert';
import 'package:perf_api/perf_api.dart';
import 'package:di/di.dart';

part 'filter/category_filter.dart';
part 'service/query_service.dart';
part 'component/rating_component.dart';
part 'service/recipe.dart';
part 'recipe_book_router.dart';
part 'view/view_recipe_component.dart';
part 'view/search_recipe_component.dart';

@NgDirective(
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

// TODO - Remove the Profiler type. It's only needed to get rid of Misko's spam
main() {
  var module = new AngularModule()
    ..type(RecipeBookController)
    ..type(RatingComponent)
    ..type(SearchRecipeComponent)
    ..type(ViewRecipeComponent)
    ..type(CategoryFilter)
    ..type(QueryService)
    ..type(RouteInitializer, implementedBy: RecipeBookRouteInitializer)
    ..factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false))
    ..type(Profiler, implementedBy: Profiler);

  ngBootstrap(module: module);
}
