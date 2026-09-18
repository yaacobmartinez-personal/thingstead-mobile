// Address and link slugs, ported from regista/lib/slug.ts so the app previews
// exactly what the server will accept.

/// Top-level route folders on the web; a tenant with one of these slugs would
/// be shadowed by a first-party surface.
const Set<String> _routeGroupNames = {'home', 'app', 'api'};

const Set<String> _conventionallyReserved = {
  'www',
  'admin',
  'mail',
  'smtp',
  'imap',
  'support',
  'login',
  'signup',
  'auth',
  'static',
  'assets',
  'cdn',
  'help',
  'status',
  'billing',
  'dashboard',
  'account',
  'security',
  'internal',
  'privacy',
};

final Set<String> reservedSlugs = {
  ..._routeGroupNames,
  ..._conventionallyReserved,
};

final RegExp _slugShape = RegExp(r'^[a-z0-9](?:[a-z0-9-]{1,61}[a-z0-9])$');

/// Turn free text into a URL segment.
String slugify(String value) {
  final cleaned = value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
      .trim()
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceAll(RegExp(r'-+'), '-');
  return cleaned.length > 63 ? cleaned.substring(0, 63) : cleaned;
}

bool isReservedSlug(String slug) => reservedSlugs.contains(slug);

/// 3–63 characters, lowercase alphanumeric with internal hyphens.
bool isValidSlugShape(String slug) => _slugShape.hasMatch(slug);

/// Syntactically valid and not reserved.
bool isUsableSlug(String slug) => !isReservedSlug(slug) && isValidSlugShape(slug);
