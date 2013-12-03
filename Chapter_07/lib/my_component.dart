library my_component;

import 'package:angular/angular.dart';

import 'service.dart';

@NgComponent(
    selector: 'my-component',
    templateUrl: 'packages/angular_dart_demo/my_component.html',
    publishAs: 'ctrl'
)
class MyComponent {
  @NgAttr('default-name')
  String name;
}