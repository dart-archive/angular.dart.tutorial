library main_test;

import 'package:unittest/unittest.dart';
import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:angular_dart_demo/recipe_book.dart';
import 'package:angular_dart_demo/rating/rating_component.dart';

import '../web/main.dart';

main() {
  setUp(() {
   setUpInjector();
   module((Module m) => m.install(new MyAppModule()));
  });
  tearDown(tearDownInjector);

  group('recipe-book', () {
    test('should load recipes', inject((RecipeBookController recipesController) {
      expect(recipesController.recipes, isNot(isEmpty));
    }));

    test('should select recipe', inject((RecipeBookController recipesController) {
      var recipe = recipesController.recipes[0];
      recipesController.selectRecipe(recipe);
      expect(recipesController.selectedRecipe, same(recipe));
    }));
  });

  group('rating component', () {
    test('should show the right number of stars', inject((RatingComponent rating) {
      rating.maxRating = '5';
      expect(rating.stars, equals([1, 2, 3, 4, 5]));
    }));

    test('should handle click', inject((RatingComponent rating) {
      rating.maxRating = '5';
      rating.handleClick(3);
      expect(rating.rating, equals(3));

      rating.handleClick(1);
      expect(rating.rating, equals(1));

      rating.handleClick(1);
      expect(rating.rating, equals(0));

      rating.handleClick(1);
      expect(rating.rating, equals(1));
    }));
  });
}
