import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

/// Browser client that sends and receives cookies on cross-origin requests.
http.Client createCredentialedClient() => BrowserClient()..withCredentials = true;