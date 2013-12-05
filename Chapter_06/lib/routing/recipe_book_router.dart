library recipe_book_routing;

import 'package:angular/angular.dart';

class RecipeBookRouteInitializer implements RouteInitializer {

  init(Router router, ViewFactory view) {
    router.root
      ..addRoute(
          name: 'add',
          path: '/add',
          enter: view('view/addRecipe.html'))
      ..addRoute(
          name: 'recipe',
          path: '/recipe/:recipeId',
          mount: (Route route) => route
              ..addRoute(
                  name: 'view',
                  path: '/view',
                  enter: view('view/viewRecipe.html'))
              ..addRoute(
                  name: 'edit',
                  path: '/edit',
                  enter: view('view/editRecipe.html'))
              ..addRoute(
                  name: 'view_default',
                  defaultRoute: true,
                  enter: (_) =>
                      router.go('view', {'recipeId': ':recipeId'},
                          startingFrom: route, replace:true)));
  }
}
