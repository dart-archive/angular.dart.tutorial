library view_recipe_component;

import '../service/recipe.dart';
import 'package:angular/angular.dart';

@NgComponent(
    selector: 'view-recipe',
    templateUrl: 'packages/angular_dart_demo/component/view_recipe_component.html',
    cssUrl: 'packages/angular_dart_demo/component/view_recipe_component.css',
    publishAs: 'ctrl'
)
class ViewRecipeComponent {
  @NgTwoWay('recipe-map')
  Map<String, Recipe> recipeMap;
  
  String _recipeId;

  Recipe get recipe {
    return recipeMap[_recipeId];
  }

  ViewRecipeComponent(RouteProvider routeProvider) {
    _recipeId = routeProvider.parameters['recipeId'];
  }
}
