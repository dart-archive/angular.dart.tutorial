library recipe_book;

import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';
import 'package:di/di.dart';
import 'package:logging/logging.dart';

import 'package:angular_dart_demo/recipe_book.dart';
import 'package:angular_dart_demo/filter/category_filter.dart';
import 'package:angular_dart_demo/rating/rating_component.dart';
import 'package:angular_dart_demo/tooltip/tooltip_directive.dart';
import 'package:angular_dart_demo/service/query_service.dart';
import 'package:angular_dart_demo/routing/recipe_book_router.dart';
import 'package:angular_dart_demo/component/view_recipe_component.dart';
import 'package:angular_dart_demo/component/search_recipe_component.dart';

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(
  targets: const ['recipe', 'query_service', 'recipe_book_routing'],
  override: '*')
import 'dart:mirrors';

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
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) { print(r.message); });
  ngBootstrap(module: new MyAppModule());
}
