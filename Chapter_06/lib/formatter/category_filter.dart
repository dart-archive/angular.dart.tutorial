library category_filter;

import 'package:angular/angular.dart';

@Formatter(name: 'categoryfilter')
class CategoryFilter {
  List call(recipeList, filterMap) {
    if (recipeList is Iterable && filterMap is Map) {
      // If there is nothing checked, treat it as "everything is checked"
      bool nothingChecked = filterMap.values.every((isChecked) => !isChecked);
      return nothingChecked
          ? recipeList
          : recipeList.where((i) => filterMap[i.category] == true).toList();
    }
    return const [];
  }
}
