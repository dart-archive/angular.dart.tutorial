import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'rating_component.dart';
import 'recipe.dart';

@NgFilter(name: 'searchfilter')
class SearchFilter {
  call(value, filterString) {
    if (value is List && filterString != null) {
      return value.where((i) => i.name.contains(filterString)).toList();
    }
    return value.toList();
  }
}

@NgDirective(
    selector: '[recipe-book]',
    publishAs: 'ctrl')
class RecipeBookController {

  Http _http;

  List categories = ["Appetizers", "Salads", "Soups", "Main Dishes",
                    "Side Dishes", "Desserts"];
  List<Recipe> recipes = [];

  RecipeBookController(Http this._http) {
    _loadData();
  }

  Recipe selectedRecipe;

  void selectRecipe(Recipe recipe) {
    selectedRecipe = recipe;
  }

  void _loadData() {
    _http.get('/angular.dart.tutorial/Chapter_04/recipes.json')
      .then((HttpResponse response) {
        for (Map recipe in response.data) {
          recipes.add(new Recipe.fromJson(recipe));
        }
      });
  }
}

main() {
  var module = new AngularModule()
    ..type(RecipeBookController)
    ..type(RatingComponent)
    ..type(SearchFilter);

  bootstrapAngular([module]);
}