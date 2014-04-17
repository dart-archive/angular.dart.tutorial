library recipe_book;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:angular_dart_demo/recipe_book.dart';
import 'package:angular_dart_demo/formatter/category_filter.dart';
import 'package:angular_dart_demo/rating/rating_component.dart';
import 'package:angular_dart_demo/tooltip/tooltip.dart';

class MyAppModule extends Module {
  MyAppModule() {
    type(RecipeBookController);
    type(RatingComponent);
    type(Tooltip);
    type(CategoryFilter);
  }
}

void main() {
  applicationFactory()
      .addModule(new MyAppModule())
      .run();
}
