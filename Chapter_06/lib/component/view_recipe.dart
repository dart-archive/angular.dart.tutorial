library view_recipe_component;

import 'package:tutorial/service/recipe.dart';
import 'package:angular/angular.dart';

@Component(
    selector: 'view-recipe',
    templateUrl: 'view_recipe.html',
    cssUrl: 'view_recipe.css')
class ViewRecipeComponent {
  @NgOneWay('recipe-map')
  Map<String, Recipe> recipeMap;

  String _recipeId;

  Recipe get recipe => recipeMap == null ? null : recipeMap[_recipeId];

  ViewRecipeComponent(RouteProvider routeProvider) {
    _recipeId = routeProvider.parameters['recipeId'];
  }
}
