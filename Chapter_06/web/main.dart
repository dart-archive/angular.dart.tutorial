library recipe_book;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';

import 'package:angular_dart_demo/recipe_book.dart';
import 'package:angular_dart_demo/filter/category_filter.dart';
import 'package:angular_dart_demo/rating/rating_component.dart';
import 'package:angular_dart_demo/tooltip/tooltip_directive.dart';
import 'package:angular_dart_demo/service/query_service.dart';
import 'package:angular_dart_demo/routing/recipe_book_router.dart';
import 'package:angular_dart_demo/component/view_recipe_component.dart';
import 'package:angular_dart_demo/component/search_recipe_component.dart';

class MyAppModule extends Module {
  MyAppModule() {
    type(RecipeBookController);
    type(RatingComponent);
    type(Tooltip);
    type(CategoryFilter);
    type(SearchRecipeComponent);
    type(ViewRecipeComponent);
    type(QueryService);
    value(RouteInitializerFn, recipeBookRouteInitializer);
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
  }
}

void main() {
  Logger.root..level = Level.FINEST
             ..onRecord.listen((LogRecord r) { print(r.message); });
  applicationFactory()
      .addModule(new MyAppModule())
      .run();
}
