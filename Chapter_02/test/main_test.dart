library main_test;

import 'package:unittest/unittest.dart';
import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';

import '../web/main.dart';

main() {
  setUp(setUpInjector);
  tearDown(tearDownInjector);

  group('recipe-book', () {
    setUp(module((Module m) => m.install(new MyAppModule())));

    test('should load recipes', inject((RecipeBookController recipesController) {
      expect(recipesController.recipes, isNot(isEmpty));
    }));

    test('should select recipe', inject((RecipeBookController recipesController) {
      var recipe = recipesController.recipes[0];
      recipesController.selectRecipe(recipe);
      expect(recipesController.selectedRecipe, same(recipe));
    }));
  });
}
