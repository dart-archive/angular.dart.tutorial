part of recipe_book;

@NgComponent(
    selector: 'view-recipe',
    templateUrl: 'view/view_recipe_component.html',
    cssUrl: 'view/view_recipe_component.css',
    publishAs: 'ctrl',
    map: const {
      'recipe-map':'<=>recipeMap'
    }
)
class ViewRecipeComponent {
  Map<String, Recipe> recipeMap;
  String _recipeId;

  get recipe {
    return recipeMap[_recipeId];
  }

  ViewRecipeComponent(RouteProvider routeProvider) {
    _recipeId = routeProvider.parameters['recipeId'];
  }
}
