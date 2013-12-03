library name_service;

import 'injectable.dart';

@InjectableService()
class NameService {

  String formatName(String name) =>
     name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase();
}