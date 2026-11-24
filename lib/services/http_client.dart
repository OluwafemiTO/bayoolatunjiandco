// Picks the right http.Client for the platform.
// Only the login calls need the cookie-enabled client; everything else uses a plain one.
export 'http_client_stub.dart' if (dart.library.js_interop) 'http_client_web.dart';