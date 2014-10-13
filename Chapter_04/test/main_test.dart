library main_test;

import 'package:unittest/unittest.dart';
import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';
import 'package:tutorial/component/recipe_book.dart';
import 'package:tutorial/component/rating.dart';

import '../web/main.dart';

main() {
  setUp(() {
    setUpInjector();
    module((Module m) => m.install(new MyAppModule()));
  });

  tearDown(tearDownInjector);

  group('recipe book component', () {
    test('should load recipes', inject((RecipeBookComponent recipeBook) {
      expect(recipeBook.recipes, isNot(isEmpty));
    }));

    test('should select recipe', inject((RecipeBookComponent recipeBook) {
      var recipe = recipeBook.recipes[0];
      recipeBook.selectRecipe(recipe);
      expect(recipeBook.selectedRecipe, same(recipe));
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
