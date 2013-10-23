part of recipe_book;

@NgComponent(
    selector: 'recipe-search',
    templateUrl: 'recipe_search_component.html',
    cssUrl: 'recipe_search_component.css',
    publishAs: 'ctrl',
    map: const {
      'name-filter-string': '<=>nameFilterString',
      'category-filter-map' : '<=>categoryFilterMap'
    }
)
class RecipeSearchComponent {
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