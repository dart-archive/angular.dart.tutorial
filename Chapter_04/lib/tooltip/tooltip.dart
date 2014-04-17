library tooltip;

import 'dart:html' as dom;
import 'package:angular/angular.dart';

@Decorator(
    selector: '[tooltip]')
class Tooltip {
  final dom.Element element;

  @NgOneWay('tooltip')
  TooltipModel displayModel;

  dom.Element tooltipElem;

  Tooltip(this.element) {
    element..onMouseEnter.listen((_) => _createTemplate())
           ..onMouseLeave.listen((_) => _destroyTemplate());
  }

  void _createTemplate() {
    assert(displayModel != null);

    tooltipElem = new dom.DivElement();

    dom.ImageElement imgElem = new dom.ImageElement()
        ..width = displayModel.imgWidth
        ..src = displayModel.imgUrl;
    tooltipElem.append(imgElem);

    if (displayModel.text != null) {
      dom.DivElement textSpan = new dom.DivElement()
          ..appendText(displayModel.text)
          ..style.color = "white"
          ..style.fontSize = "smaller"
          ..style.paddingBottom = "5px";

      tooltipElem.append(textSpan);
    }

    tooltipElem.style
        ..padding = "5px"
        ..paddingBottom = "0px"
        ..backgroundColor = "black"
        ..borderRadius = "5px"
        ..width = "${displayModel.imgWidth.toString()}px";

    // position the tooltip.
    var elTopRight = element.offset.topRight;

    tooltipElem.style
        ..position = "absolute"
        ..top = "${elTopRight.y}px"
        ..left = "${elTopRight.x + 10}px";

    // Add the tooltip to the document body. We add it here because
    // we need to position it absolutely, without reference to its
    // parent element.
    dom.document.body.append(tooltipElem);
  }

  void _destroyTemplate() {
    tooltipElem.remove();
  }
}

class TooltipModel {
  String imgUrl;
  String text;
  int imgWidth;

  TooltipModel(this.imgUrl, this.text, this.imgWidth);
}
