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
class ViewRecipeComponent implements NgDetachAware {
  RouteHandle _route;
  Map<String, Recipe> recipeMap;
  Recipe _recipe;

  get recipe {
    return recipeMap[_route.parameters['recipeId']];
  }

  ViewRecipeComponent(RouteProvider routeProvider) {
    _route = routeProvider.route;
  }

  void detach() {
    _route.discard();
  }
}