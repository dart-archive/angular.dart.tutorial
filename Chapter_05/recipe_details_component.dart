part of recipe_book;

@NgComponent(
    selector: 'recipe-details',
    templateUrl: 'recipe_details_component.html',
    cssUrl: 'recipe_details_component.css',
    publishAs: 'ctrl',
    map: const {
      'recipe-map':'<=>recipeMap'
    }
)
class RecipeDetailsComponent implements NgDetachAware {
  RouteHandle _route;
  Map<String, Recipe> recipeMap;
  Recipe _recipe;

  get recipe {
    return recipeMap[_route.parameters['recipeId']];
  }

  RecipeDetailsComponent(RouteProvider routeProvider) {
    _route = routeProvider.route;
  }

  void detach() {
    _route.discard();
  }
}