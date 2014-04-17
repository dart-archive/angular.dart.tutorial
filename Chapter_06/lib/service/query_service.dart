library query_service;

import 'dart:async';

import 'recipe.dart';
import 'package:angular/angular.dart';

@Injectable()
class QueryService {
  String _recipesUrl = 'recipes.json';
  String _categoriesUrl = 'categories.json';

  Future _loaded;

  Map<String, Recipe> _recipesCache;
  List<String> _categoriesCache;

  final Http _http;

  QueryService(Http this._http) {
    _loaded = Future.wait([_loadRecipes(), _loadCategories()]);
  }

  Future _loadRecipes() {
    return _http.get(_recipesUrl)
      .then((HttpResponse response) {
        _recipesCache = new Map<String, Recipe>();
        for (Map recipe in response.data) {
          Recipe r = new Recipe.fromJson(recipe);
          _recipesCache[r.id] = r;
        }
      });
  }

  Future _loadCategories() {
    return _http.get(_categoriesUrl).then((HttpResponse response) {
      _categoriesCache = response.data;
    });
  }

  Future<Recipe> getRecipeById(String id) {
    return _recipesCache == null
        ? _loaded.then((_) => _recipesCache[id])
        : new Future.value(_recipesCache[id]);
  }

  Future<Map<String, Recipe>> getAllRecipes() {
    return _recipesCache == null
        ? _loaded.then((_) => _recipesCache)
        : new Future.value(_recipesCache);
  }

  Future<List<String>> getAllCategories() {
    return _categoriesCache == null
        ? _loaded.then((_) => _categoriesCache)
        : new Future.value(_categoriesCache);
  }
}
