import 'dart:io';
import 'package:http_server/http_server.dart' show VirtualDirectory;

final String PATH_TO_WEB_CONTENT = "../web";

void main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 3031).then((HttpServer server) {
    print("Server up; try http://${server.address.address}:${server.port}/index.html");
    final String root = Platform.script.resolve(PATH_TO_WEB_CONTENT).toFilePath();
    final virDir = new VirtualDirectory(root)
        // The following are needed in dev mode to be able to access
        // Dart packages in the cache.
        ..followLinks = true
        ..jailRoot = false;
    server.listen((HttpRequest req) {
      print("${req.method} ${req.uri};\tcached ${req.headers.ifModifiedSince}");
      (req.method == "PUT" ? processPut : virDir.serveRequest)(req);
    });
  });
}

void processPut(HttpRequest request) {
  final String filePath = request.uri.toFilePath();
  final File file = new File(PATH_TO_WEB_CONTENT + filePath);
  request.pipe(file.openWrite()).then((_) {
    request.response
        ..statusCode = HttpStatus.NO_CONTENT
        ..close();
    print("Wrote to file '${file.path}'");
  });
}
