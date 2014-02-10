library rating;

import 'package:angular/angular.dart';

/* Use the NgComponent annotation to indicate that this class is an
 * Angular Component.
 *
 * The selector field defines the CSS selector that will trigger the
 * component. Typically, the CSS selector is an element name.
 *
 * The templateUrl field tells the component which HTML template to use
 * for its view.
 *
 * The cssUrl field tells the component which CSS file to use.
 *
 * The publishAs field specifies that the component instance should be
 * assigned to the current scope under the name specified.
 *
 * The map field publishes the list of attributes that can be set on
 * the component. Users of this component will specify these attributes
 * in the html tag that is used to create the component. For example:
 *
 * <rating max-rating="5" rating="mycontrol.rating">
 *
 * The compnoent's public fields are available for data binding from the
 * component's view. Similarly, the component's public methods can be
 * invoked from the component's view.
 */
@NgComponent(
    selector: 'rating',
    templateUrl: 'packages/angular_dart_demo/rating/rating_component.html',
    cssUrl: 'packages/angular_dart_demo/rating/rating_component.css',
    publishAs: 'ctrl'
)
class RatingComponent {
  String _starOnChar = "\u2605";
  String _starOffChar = "\u2606";
  String _starOnClass = "star-on";
  String _starOffClass = "star-off";

  List<int> stars = [];

  @NgTwoWay('rating')
  int rating;

  @NgAttr('max-rating')
  set maxRating(String value) {
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
