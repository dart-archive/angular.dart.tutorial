library rating;

import 'package:angular/angular.dart';

/* Use the @Component annotation to indicate that this class is an
 * Angular component.
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
 * The class field and setter annotated with @NgTwoWay and @NgAttr,
 * respectively, identify the attributes that can be set on
 * the component. Users of this component will specify these attributes
 * in the HTML tag that is used to create the component. For example:
 *
 * <rating max-rating="5" rating="mycontrol.rating">
 *
 * The component's public fields are available for data binding from the
 * component's view. Similarly, the component's public methods can be
 * invoked from the component's view.
 */
@Component(
    selector: 'rating',
    templateUrl: 'rating.html',
    cssUrl: 'rating.css')
class RatingComponent {
  static const String _STAR_ON_CHAR = "\u2605";
  static const String _STAR_OFF_CHAR = "\u2606";
  static const String _STAR_ON_CLASS = "star-on";
  static const String _STAR_OFF_CLASS = "star-off";

  static final int DEFAULT_MAX = 5;

  List<int> stars = [];

  @NgTwoWay('rating')
  int rating;

  @NgAttr('max-rating')
  void set maxRating(String value) {
    var count = value == null
        ? DEFAULT_MAX
        : int.parse(value, onError: (_) => DEFAULT_MAX);
    stars = new List.generate(count, (i) => i + 1);
  }

  String starClass(int star) => star > rating ? _STAR_OFF_CLASS : _STAR_ON_CLASS;

  String starChar(int star) => star > rating ? _STAR_OFF_CHAR : _STAR_ON_CHAR;

  void handleClick(int star) {
    rating = (star == 1 && rating == 1) ? 0 : star;
  }
}
