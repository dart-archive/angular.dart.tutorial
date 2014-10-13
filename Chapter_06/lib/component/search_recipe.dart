library search_recipe_component;

import 'package:angular/angular.dart';

@Component(
    selector: 'search-recipe',
    templateUrl: 'search_recipe.html')
class SearchRecipeComponent {
  Map<String, bool> _categoryFilterMap;
  List<String> _categories;
  List<String> get categories => _categories;

  @NgTwoWay('name-filter-string')
  String nameFilterString = "";

  @NgOneWay('category-filter-map')
  Map<String, bool> get categoryFilterMap => _categoryFilterMap;
  void set categoryFilterMap(values) {
    _categoryFilterMap = values;
    _categories = categoryFilterMap.keys.toList();
  }

  void clearFilters() {
    _categoryFilterMap.keys.forEach((f) => _categoryFilterMap[f] = false);
    nameFilterString = "";
  }
}
