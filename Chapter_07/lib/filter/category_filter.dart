library category_filter;

import 'package:angular/angular.dart';

@NgFilter(name: 'categoryfilter')
class CategoryFilter {
  call(recipeList, filterMap) {
    if (recipeList is List && filterMap is Map) {
      // If there is nothing checked, treat it as "everything is checked"
      bool nothingChecked = filterMap.values.every((isChecked) => !isChecked);
      if (nothingChecked) {
        return recipeList.toList();
      }
      return recipeList.where((i) => filterMap[i.category] == true).toList();
    }
  }
}

