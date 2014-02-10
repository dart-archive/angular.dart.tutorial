library search_recipe_component;

import 'package:angular/angular.dart';

@NgComponent(
    selector: 'search-recipe',
    templateUrl: 'packages/angular_dart_demo/component/search_recipe_component.html',
    publishAs: 'ctrl'
)
class SearchRecipeComponent {
  @NgTwoWay('name-filter-string')
  String nameFilterString = "";
  
  @NgTwoWay('category-filter-map')
  Map<String, bool> categoryFilterMap;

  List<String> get categories {
    return categoryFilterMap.keys.toList();
  }

  void clearFilters() {
    categoryFilterMap.keys.forEach((f) => categoryFilterMap[f] = false);
    nameFilterString = "";
  }
}