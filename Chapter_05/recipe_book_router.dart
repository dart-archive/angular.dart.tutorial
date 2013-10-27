part of recipe_book;

class RecipeBookRouteInitializer implements RouteInitializer {

  init(Router router, ViewFactory view) {
    router.root
      ..addRoute(
          name: 'add',
          path: '/add',
          enter: view('view/add.html'))
      ..addRoute(
          name: 'recipe',
          path: '/recipe/:recipeId',
          mount: (Route route) => route
              ..addRoute(
                  name: 'view',
                  path: '/view',
                  enter: view('view/view.html'))
              ..addRoute(
                  name: 'edit',
                  path: '/edit',
                  enter: view('view/edit.html'))
              ..addRoute(
                  name: 'view_default',
                  defaultRoute: true,
                  enter: (_) =>
                      router.go('view', {'recipeId': ':recipeId'},
                          startingFrom: route, replace:true)));
  }
}
