// Used by di codegen to identify instantiable types.
@Injectables(const [
    Profiler
])
library recipe_book;

// Used by dart2js to indicate which targets are being reflected on, to allow
// tree-shaking.
@MirrorsUsed(
    targets: const [
        'angular.core',
        'angular.core.dom',
        'angular.core.parser',
        'angular.routing',
        NodeTreeSanitizer
    ],
    metaTargets: const [
        NgInjectableService,
        NgComponent,
        NgDirective,
        NgController,
        NgFilter,
        NgAttr,
        NgOneWay,
        NgOneWayOneTime,
        NgTwoWay,
        NgCallback
    ],
    override: '*'
)
import 'dart:mirrors';

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:logging/logging.dart';
import 'package:perf_api/perf_api.dart';

import 'package:angular_dart_demo/injectable.dart';
import 'package:angular_dart_demo/recipe_book.dart';
import 'package:angular_dart_demo/filter/category_filter.dart';
import 'package:angular_dart_demo/rating/rating_component.dart';
import 'package:angular_dart_demo/tooltip/tooltip_directive.dart';
import 'package:angular_dart_demo/service/query_service.dart';
import 'package:angular_dart_demo/service/recipe.dart';
import 'package:angular_dart_demo/routing/recipe_book_router.dart';
import 'package:angular_dart_demo/component/view_recipe_component.dart';
import 'package:angular_dart_demo/component/search_recipe_component.dart';


// During development it's easier to use dynamic parser and injector, so use
// initializer-dev.dart instead. Before using initializer-prod.dart make sure
// you run: dart -c bin/generator.dart
import 'initializer-prod.dart' as init; // Use in prod/test.
// import 'initializer-dev.dart' as init; // Use in dev.

class MyAppModule extends Module {
  MyAppModule() {
    type(RecipeBookController);
    type(RatingComponent);
    type(Tooltip);
    type(CategoryFilter);
    type(Profiler, implementedBy: Profiler); // comment out to enable profiling
    type(SearchRecipeComponent);
    type(ViewRecipeComponent);
    type(QueryService);
    type(RouteInitializer, implementedBy: RecipeBookRouteInitializer);
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));

    init.createParser(this);
  }
}

main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) { print(r.message); });
  ngBootstrap(module: new MyAppModule(), injectorFactory: init.createInjector);
}
