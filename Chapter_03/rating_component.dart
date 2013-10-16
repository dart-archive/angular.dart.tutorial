import 'package:angular/angular.dart';

/* Use the NgComponent annotation to indicate that this class is an
 * Angular Component.
 *
 * The selector field defines the CSS selector that will trigger the
 * component. Typically, the CSS selector is an element name.
 *
 * TODO: adopt new map naming conventions as soon as they're ready.
 *   'max': '@.max'
 *   will become
 *   'max-rating': '@maxRating'
 */
@NgComponent(
    selector: 'rating',
    templateUrl: 'rating_component.html',
    cssUrl: 'rating_component.css',
    publishAs: 'ctrl',
    map: const {
      'max': '@.max',
      'rating' : '=.rating'
    }
)
class RatingComponent {
  String _starOnChar = "\u2605";
  String _starOffChar = "\u2606";
  String _starOnClass = "star-on";
  String _starOffClass = "star-off";

  List<int> stars = [];

  int rating;

  set max(String value) {
    stars = [];
    var count = value == null ? 5 : int.parse(value);
    for(var i=1; i <= count; i++) {
      stars.add(i);
    }
  }

  String starClass(int star) {
    return star > rating ? _starOffClass : _starOnClass;
  }

  String starChar(int star) {
    return star > rating ? _starOffChar : _starOnChar;
  }

  void handleClick(int star) {
    if (star == 1 && rating == 1) {
      rating = 0;
    } else {
      rating = star;
    }
  }
}
