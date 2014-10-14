library recipe_book;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:tutorial/component/recipe_book.dart';

class MyAppModule extends Module {
  MyAppModule() {
    bind(RecipeBookComponent);
  }
}

void main() {
  applicationFactory()
      .addModule(new MyAppModule())
      .run();
}
