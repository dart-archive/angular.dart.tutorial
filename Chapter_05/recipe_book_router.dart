part of recipe_book;

class RecipeBookRouteInitializer implements RouteInitializer {

  init(Router router, ViewFactory view) {
    router.root
      ..addRoute(
          name: 'add', // recipe_add
          path: '/add', // /recipe/add
          enter: view('view/add.html')) // recipe_add.html
      ..addRoute(
          name: 'recipe',
          path: '/recipe/:recipeId',
          mount: (Route route) => route
              ..addRoute(
                  name: 'view', // recipe
                  path: '/view', // delete this
                  enter: view('view/view.html')) // recipe.html
              ..addRoute(
                  name: 'edit', // recipe_edit
                  path: '/edit',
                  enter: view('view/edit.html')) // recipe_edit.html
              ..addRoute(
                  name: 'view_default',
                  defaultRoute: true,
                  enter: (_) =>
                      router.go('view', {'recipeId': ':recipeId'},
                          startingFrom: route, replace:true)));
  }
}
