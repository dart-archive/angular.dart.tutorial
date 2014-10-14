library main_test;

import 'package:unittest/unittest.dart';
import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:tutorial/component/recipe_book.dart';

import '../web/main.dart';

main() {
  setUp(setUpInjector);
  tearDown(tearDownInjector);

  group('recipe book component', () {
    setUp(module((Module m) => m.install(new MyAppModule())));

    test('should load recipes', inject((RecipeBookComponent recipeBook) {
      expect(recipeBook.recipes, isNot(isEmpty));
    }));

    test('should select recipe', inject((RecipeBookComponent recipeBook) {
      var recipe = recipeBook.recipes[0];
      recipeBook.selectRecipe(recipe);
      expect(recipeBook.selectedRecipe, same(recipe));
    }));
  });
}
