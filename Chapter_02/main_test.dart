library main_test;

import 'package:unittest/unittest.dart';
import 'package:di/di.dart';
import 'package:di/dynamic_injector.dart';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';

import 'main.dart';

main() {
  group('recipe-book', () {
    TestBed _;
    RecipeBookController recipesController;

    setUp(() {
      var injector = new DynamicInjector(modules: [
        new AngularModule()..type(RecipeBookController),
        new AngularMockModule()
      ]);
      _ = injector.get(TestBed);
      recipesController = _.injector.get(RecipeBookController);
    });

    test('should load recipes', () {
      expect(recipesController.recipes, isNot(isEmpty));
    });

    test('should select recipe', () {
      var recipe = recipesController.recipes[0];
      recipesController.selectRecipe(recipe);
      expect(recipesController.selectedRecipe, same(recipe));
    });
  });
}
