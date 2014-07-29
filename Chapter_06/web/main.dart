library recipe_book;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';

import 'package:angular_dart_demo/recipe_book.dart';
import 'package:angular_dart_demo/formatter/category_filter.dart';
import 'package:angular_dart_demo/rating/rating_component.dart';
import 'package:angular_dart_demo/tooltip/tooltip.dart';
import 'package:angular_dart_demo/service/query_service.dart';
import 'package:angular_dart_demo/routing/recipe_book_router.dart';
import 'package:angular_dart_demo/component/view_recipe_component.dart';
import 'package:angular_dart_demo/component/search_recipe_component.dart';

class MyAppModule extends Module {
  MyAppModule() {
    Binding.printInjectWarning = false;   // needed for https://github.com/angular/angular.dart/issues/1272

    bind(RecipeBookController);
    bind(RatingComponent);
    bind(Tooltip);
    bind(CategoryFilter);
    bind(SearchRecipeComponent);
    bind(ViewRecipeComponent);
    bind(QueryService);
    bind(RouteInitializerFn, toValue: recipeBookRouteInitializer);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
  }
}

void main() {
  Logger.root..level = Level.FINEST
             ..onRecord.listen((LogRecord r) { print(r.message); });
  applicationFactory()
      .addModule(new MyAppModule())
      .run();
}
