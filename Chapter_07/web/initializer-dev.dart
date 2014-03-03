library app_initializer_dev;

import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:di/dynamic_injector.dart';

createInjector(List<Module> modules) => new DynamicInjector(modules: modules);

createParser(Module module) {
  // Do nothing, user default DynamicParser.
}