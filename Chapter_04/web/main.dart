library recipe_book;

import 'package:angular/angular.dart';
import 'package:di/di.dart';

import 'package:angular_dart_demo/recipe_book.dart';
import 'package:angular_dart_demo/rating/rating_component.dart';
import 'package:angular_dart_demo/tooltip/tooltip_directive.dart';

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(
	targets: const ['recipe_book_controller'],
	override: '*')
import 'dart:mirrors';

class MyAppModule extends Module {
  MyAppModule() {
    type(RecipeBookController);
    type(RatingComponent);
    type(Tooltip);
  }
}

void main() {
  ngBootstrap(module: new MyAppModule());
}
