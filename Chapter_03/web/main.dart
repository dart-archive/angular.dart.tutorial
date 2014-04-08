library recipe_book;

import 'package:angular/angular.dart';
import 'package:angular/angular_dynamic.dart';

import 'package:angular_dart_demo/rating/rating_component.dart';
import 'package:angular_dart_demo/recipe_book.dart';

class MyAppModule extends Module {
  MyAppModule() {
    type(RecipeBookController);
    type(RatingComponent);
  }
}

void main() {
  dynamicApplication()
      .addModule(new MyAppModule())
      .run();
}
