library recipe_book;

import 'package:angular/angular.dart';
import 'package:angular/angular_dynamic.dart';

import 'package:angular_dart_demo/recipe_book.dart';
import 'package:angular_dart_demo/filter/category_filter.dart';
import 'package:angular_dart_demo/rating/rating_component.dart';
import 'package:angular_dart_demo/tooltip/tooltip_directive.dart';

class MyAppModule extends Module {
  MyAppModule() {
    type(RecipeBookController);
    type(RatingComponent);
    type(Tooltip);
    type(CategoryFilter);
  }
}

void main() {
  dynamicApplication()
      .addModule(new MyAppModule())
      .run();
}
