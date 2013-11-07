@MirrorsUsed(targets: const[
  'angular',
  'angular.core',
  'angular.core.dom',
  'angular.filter',
  'angular.perf',
  'angular.directive',
  'angular.routing',
  'angular.core.parser',
  'NodeTreeSanitizer'
  ],
  override: '*')
import 'dart:mirrors';
import 'package:angular/angular.dart';

main() => ngBootstrap();
