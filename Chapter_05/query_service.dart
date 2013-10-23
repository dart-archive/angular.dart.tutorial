part of recipe_book;

class QueryService {
  String _recipesUrl = '/angular.dart.tutorial/Chapter_05/recipes.json';
  String _categoriesUrl = '/angular.dart.tutorial/Chapter_05/categories.json';

  Map<String, Recipe> _recipes = {};
  List<String> _categories = [];

  bool _recipesLoaded = false;
  bool _categoriesLoaded = false;
  Http _http;

  QueryService(Http this._http);

  void loadData() {
    _recipesLoaded = false;
    _categoriesLoaded = false;

    _http.get(_recipesUrl)
      .then((HttpResponse response) {
        for (Map recipe in response.data) {
          Recipe r = new Recipe.fromJsonMap(recipe);
          _recipes[r.id] = r;
        }
        _recipesLoaded = true;
      },
      onError: (Object obj) {
        _recipesLoaded = false;
      });

    _http.get(_categoriesUrl)
        .then((HttpResponse response) {
      for (String category in response.data) {
        _categories.add(category);
      }
      _categoriesLoaded = true;
    },
    onError: (Object obj) {
      _categoriesLoaded = false;
    });
  }

  Recipe getRecipeById(String id) {
    return _recipes[id];
  }

  List<Recipe> getAllRecipes() {
    return _recipes.values.toList();
  }

  bool get recipesLoaded => _recipesLoaded;

  bool get categoriesLoaded => _categoriesLoaded;

}