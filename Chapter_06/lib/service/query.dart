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

  Future _loadRecipes() async {
    try {
      var response = await _http.get(_recipesUrl);
      _recipesCache = new Map<String, Recipe>();

      for (Map recipe in response.data) {
        Recipe r = new Recipe.fromJson(recipe);
        _recipesCache[r.id] = r;
      }
    } on Error catch(e){
      throw(e);
    }
  }

  Future _loadCategories() async {
    try {
      var response = await _http.get(_categoriesUrl);
      _categoriesCache = response.data;
    } on Error catch(e){
      throw(e);
    }
  }

  Future<Recipe> getRecipeById(String id) async {
    try {
      if (_recipesCache == null) await _loaded;
      return _recipesCache[id];
    } on Error catch(e){
      throw(e);
    }
  }

  Future<Map<String, Recipe>> getAllRecipes() async {
    try {
      if (_recipesCache == null) await _loaded;
      return _recipesCache;
    } on Error catch(e){
      throw(e);
    }
  }

  Future<List<String>> getAllCategories() async {
    try {
      if (_categoriesCache == null) await _loaded;
      return _categoriesCache;
    } on Error catch(e){
      throw(e);
    }
  }
}
