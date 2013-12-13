library recipe_book;

import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:perf_api/perf_api.dart';

import '../lib/rating/rating_component.dart';
import '../lib/recipe_book.dart';

class MyAppModule extends Module {
  MyAppModule() {
    type(RecipeBookController);
    type(RatingComponent);
    type(Profiler, implementedBy: Profiler); // comment out to enable profiling
  }
}

main() {
  ngBootstrap(module: new MyAppModule());
}
