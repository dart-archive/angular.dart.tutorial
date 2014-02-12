library recipe_book_routing;

import 'package:angular/angular.dart';

recipeBookRouteInitializer(Router router, ViewFactory views) =>
    views.configure({
      'add': ngRoute(
          path: '/add',
          view: 'view/addRecipe.html'),
      'recipe': ngRoute(
          path: '/recipe/:recipeId',
          mount: {
            'view': ngRoute(
                path: '/view',
                view: 'view/viewRecipe.html'),
            'edit': ngRoute(
                path: '/edit',
                view: 'view/editRecipe.html'),
            'view_default': ngRoute(
                defaultRoute: true,
                enter: (RouteEnterEvent e) =>
                    router.go('view', {},
                        startingFrom: router.root.getRoute('recipe'),
                        replace: true))
          })
    });
