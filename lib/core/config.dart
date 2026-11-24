/// Base URL of your Fastify API, no trailing slash.
///
///   flutter run -d chrome --dart-define=API_BASE=http://localhost:3000
///   flutter build web --dart-define=API_BASE=https://api.yourdomain.com
const apiBase = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:3000');

/// The public website, used for "View" links in the admin.
const siteUrl = String.fromEnvironment('SITE_URL', defaultValue: 'https://bayoolatunjiandco.com');