part of recipe_book;

@NgDirective(
    selector: '[tooltip]',
    map: const {
      'tooltip': '=>displayModel'
    }
)
class Tooltip {
  // not sure which one I will need.
  // ng-click uses node.
  // ng-show-hide uses element.
  dom.Element element;
  dom.Node node;
  Scope scope;
  TooltipModel displayModel;

  dom.Element tooltipElem;

  Tooltip(dom.Element this.element, dom.Node this.node,
      Scope this.scope) {

    element.onMouseEnter.listen((event) {
      _createTemplate();
    });

    element.onMouseLeave.listen((event) {
      _destroyTemplate();
    });
  }

  _createTemplate() {
    assert(displayModel != null);

    tooltipElem = new dom.DivElement();

    dom.ImageElement imgElem = new dom.ImageElement();
    imgElem.width = displayModel.imgWidth;
    imgElem.src = displayModel.imgUrl;
    tooltipElem.append(imgElem);

    if (displayModel.text != null) {
      dom.DivElement textSpan = new dom.DivElement();
      textSpan.appendText(displayModel.text);
      textSpan.style.color = "white";
      textSpan.style.fontSize = "smaller";
      textSpan.style.paddingBottom = "5px";

      tooltipElem.append(textSpan);
    }

    tooltipElem.style.padding = "5px";
    tooltipElem.style.paddingBottom = "0px";
    tooltipElem.style.backgroundColor = "black";
    tooltipElem.style.borderRadius = "5px";
    tooltipElem.style.width = "${displayModel.imgWidth.toString()}px";

    // find the coordinates of the parent DOM element
    Rectangle bounds = element.getBoundingClientRect();
    int left = (bounds.left + dom.window.pageXOffset).toInt();
    int top = (bounds.top + dom.window.pageYOffset).toInt();
    int width = (bounds.width).toInt();
    int height = (bounds.height).toInt();

    // position the tooltip.
    // Figure out where the containing element sits in the window.
    int tooltipLeft = left + width + 10;
    int tooltipTop = top - height;
    tooltipElem.style.position = "absolute";
    tooltipElem.style.top = "${tooltipTop}px";
    tooltipElem.style.left = "${tooltipLeft}px";

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

  TooltipModel(String this.imgUrl, String this.text,
      int this.imgWidth);
}
