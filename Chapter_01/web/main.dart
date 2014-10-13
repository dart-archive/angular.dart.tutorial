import 'package:angular/application_factory.dart';
import 'package:di/annotations.dart';

@Injectable()
class Greeter {
  String name;
}

void main() {
  applicationFactory()
      .rootContextType(Greeter)
      .run();
}
