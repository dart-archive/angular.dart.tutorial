// Used by di codegen to identify instantiable types.
@Injectables(const [
    Profiler
])
library recipe_book;

// Used by dart2js to indicate which targets are being reflected on, to allow
// tree-shaking.
@MirrorsUsed(
    targets: const [
        'angular.core',
        'angular.core.dom',
        'angular.core.parser',
        'angular.routing',
        NodeTreeSanitizer
    ],
    metaTargets: const [
        NgInjectableService,
        NgComponent,
        NgDirective,
        NgController,
        NgFilter,
        NgAttr,
        NgOneWay,
        NgOneWayOneTime,
        NgTwoWay,
        NgCallback
    ],
    override: '*'
)
import 'dart:mirrors';

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:perf_api/perf_api.dart';
import 'package:logging/logging.dart';

import 'package:angular_dart_demo/my_component.dart';
import 'package:angular_dart_demo/service.dart';

// During development it's easier to use dynamic parser and injector, so use
// initializer-dev.dart instead. Before using initializer-prod.dart make sure
// you run: dart -c bin/generator.dart
import 'initializer-prod.dart' as init; // Use in prod/test.
// import 'initializer-dev.dart' as init; // Use in dev.

class MyAppModule extends Module {
  MyAppModule() {
    type(MyComponent);
    type(NameService);
    init.createParser(this);
  }
}

main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) {
    window.console.log(r.message);
  });

  ngBootstrap(module: new MyAppModule(), injectorFactory: init.createInjector);
}
