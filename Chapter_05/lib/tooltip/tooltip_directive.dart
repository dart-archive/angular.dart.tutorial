library tooltip;

import 'dart:html' as dom;
import 'dart:math';
import 'package:angular/angular.dart';

@NgDirective(
    selector: '[tooltip]'
)
class Tooltip {
  dom.Element element;
  
  @NgOneWay('tooltip')
  TooltipModel displayModel;

  dom.Element tooltipElem;

  Tooltip(this.element) {
    element
      ..onMouseEnter.listen((_) => _createTemplate())
      ..onMouseLeave.listen((_) => _destroyTemplate());
  }

  _createTemplate() {
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

    // find the coordinates of the parent DOM element
    Rectangle bounds = element.getBoundingClientRect();
    int left = (bounds.left + dom.window.pageXOffset).toInt();
    int top = (bounds.top + dom.window.pageYOffset).toInt();
    int width = bounds.width.toInt();
    int height = bounds.height.toInt();

    // position the tooltip.
    // Figure out where the containing element sits in the window.
    tooltipElem.style
      ..position = "absolute"
      ..top = "${top - height}px"
      ..left = "${left + width + 10}px";

    // Add the tooltip to the document body. We add it here because
    // we need to position it absolutely, without reference to its
    // parent element.
    dom.document.body.append(tooltipElem);
  }

  _destroyTemplate() {
    tooltipElem.remove();
  }
}

class TooltipModel {
  String imgUrl;
  String text;
  int imgWidth;

  TooltipModel(this.imgUrl, this.text, this.imgWidth);
}
