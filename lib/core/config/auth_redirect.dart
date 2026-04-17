/// Must match [Authentication > URL Configuration > Redirect URLs] in Supabase Dashboard
/// and native deep-link setup (Android intent-filter + iOS CFBundleURLTypes).
///
/// Format: reverse-domain scheme + host (no https).
const String kAuthDeepLinkRedirect = 'com.hestora.hestora://auth-callback';
