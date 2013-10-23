library recipe_book;

import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';
import 'dart:convert';
import 'package:perf_api/perf_api.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';

part 'category_filter.dart';
part 'query_service.dart';
part 'rating_component.dart';
part 'recipe.dart';
part 'recipe_book_router.dart';
part 'recipe_details_component.dart';
part 'recipe_search_component.dart';

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
  List categories = [];
  List<Recipe> recipes = [];

  // get rid of this and replace with a recipe service
  Map<String, Recipe> recipeMap = {};

  List<Recipe> get foofoo => recipeMap.values.toList();

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
    recipesLoaded = false;
    categoriesLoaded = false;

//    _queryService.loadData();
//    recipesLoaded = _queryService.recipesLoaded;
//    categoriesLoaded = _queryService.categoriesLoaded;
//
//    if (!recipesLoaded || !categoriesLoaded) {
//      message = ERROR_MESSAGE;
//    }

    _http.get('/angular.dart.tutorial/Chapter_05/recipes.json')
      .then((HttpResponse response) {
        for (Map recipe in response.data) {
          Recipe r = new Recipe.fromJsonMap(recipe);
          recipes.add(r);
          recipeMap[r.id] = r;
        }
        recipesLoaded = true;
        for (Recipe r in recipeMap.values) {
          print(r.name);
        }
      },
      onError: (Object obj) {
        recipesLoaded = false;
        message = ERROR_MESSAGE;
      });

    _http.get('/angular.dart.tutorial/Chapter_05/categories.json')
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
//  Logger.root.level = Level.FINEST;
//  Logger.root.onRecord.listen((LogRecord r) { print(r.message); });

  var module = new AngularModule()
    ..type(RecipeBookController)
    ..type(RatingComponent)
    ..type(RecipeSearchComponent)
    ..type(RecipeDetailsComponent)
    ..type(CategoryFilter)
    ..type(QueryService)
    ..type(RouteInitializer, implementedBy: RecipeBookRouteInitializer)
    ..factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false))
    ..type(Profiler, implementedBy: Profiler);

  ngBootstrap(module: module);
}
