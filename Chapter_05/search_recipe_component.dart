part of recipe_book;

@NgComponent(
    selector: 'search-recipe',
    templateUrl: 'search_recipe_component.html',
    cssUrl: 'search_recipe_component.css',
    publishAs: 'ctrl',
    map: const {
      'name-filter-string': '<=>nameFilterString',
      'category-filter-map' : '<=>categoryFilterMap'
    }
)
class SearchRecipeComponent {
  String nameFilterString = "";
  Map categoryFilterMap;

  get categories {
    return categoryFilterMap.keys.toList();
  }

  void clearFilters() {
    categoryFilterMap.keys.forEach((f) => categoryFilterMap[f] = false);
    nameFilterString = "";
  }
}