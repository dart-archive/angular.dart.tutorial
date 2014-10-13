library recipe_book;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:tutorial/component/recipe_book.dart';
import 'package:tutorial/component/rating.dart';
import 'package:tutorial/tooltip/tooltip.dart';

class MyAppModule extends Module {
  MyAppModule() {
    bind(RecipeBookComponent);
    bind(RatingComponent);
    bind(Tooltip);
  }
}

void main() {
  applicationFactory()
      .addModule(new MyAppModule())
      .run();
}
