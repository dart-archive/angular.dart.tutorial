library app_initializer_dev;

import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:di/dynamic_injector.dart';

createInjector(List<Module> modules) {
  return new DynamicInjector(modules: modules, allowImplicitInjection: false);
}

createParser(Module module) {
  // Do nothing, user default DynamicParser.
}