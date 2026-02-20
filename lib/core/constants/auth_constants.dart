import 'package:flutter/foundation.dart' show kIsWeb;

/// Auth-related constants
///
/// **Option A - Meta tag** (in web/index.html): Set the google-signin-client_id meta tag.
/// **Option B - Code**: Set kGoogleSignInWebClientId below for web.
///
/// Get your Web Client ID from:
/// Google Cloud Console → your Firebase project → APIs & Credentials → Credentials
/// → "Web client (auto created by Google Service)" or create OAuth 2.0 Client ID (Web application)
const String? kGoogleSignInWebClientId = null;

/// Returns the Google Sign-In client ID for web, or null (then reads from meta tag)
String? get googleSignInClientId =>
    kIsWeb ? kGoogleSignInWebClientId : null;
