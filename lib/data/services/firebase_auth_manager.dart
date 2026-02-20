import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/auth_constants.dart';

/// Result of an auth operation - either success with User or failure with message
sealed class AuthResult {}

class AuthSuccess extends AuthResult {
  final User? user;

  AuthSuccess([this.user]);
}

class AuthFailure extends AuthResult {
  final String message;

  AuthFailure(this.message);
}

/// Firebase Auth Manager - centralizes all Firebase Auth operations
/// Provides a clean API for sign in, sign up, sign out, and auth state
class FirebaseAuthManager {
  FirebaseAuthManager({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              clientId: kIsWeb && googleSignInClientId != null
                  ? googleSignInClientId
                  : null,
            );

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  /// Current signed-in user, or null
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes - emits user on sign in/out
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user != null) return AuthSuccess(user);
      return AuthFailure('Sign in failed');
    } on FirebaseAuthException catch (e) {
      return AuthFailure(_getUserFriendlyMessage(e.code));
    } catch (e) {
      return AuthFailure(e.toString());
    }
  }

  /// Create account with email and password
  Future<AuthResult> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        if (displayName != null && displayName.isNotEmpty) {
          await user.updateDisplayName(displayName);
          await user.reload();
        }
        return AuthSuccess(_auth.currentUser);
      }
      return AuthFailure('Sign up failed');
    } on FirebaseAuthException catch (e) {
      return AuthFailure(_getUserFriendlyMessage(e.code));
    } catch (e) {
      return AuthFailure(e.toString());
    }
  }

  /// Sign out current user (Firebase + Google if signed in with Google)
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return AuthSuccess();
    } on FirebaseAuthException catch (e) {
      return AuthFailure(_getUserFriendlyMessage(e.code));
    } catch (e) {
      return AuthFailure(e.toString());
    }
  }

  /// Sign in with Google
  /// Enable "Google" sign-in method in Firebase Console > Authentication
  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthFailure('Sign in was cancelled.');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) return AuthSuccess(user);
      return AuthFailure('Sign in failed');
    } on FirebaseAuthException catch (e) {
      return AuthFailure(_getUserFriendlyMessage(e.code));
    } catch (e) {
      return AuthFailure(e.toString());
    }
  }

  /// Sign in with Facebook
  /// Requires: flutter_facebook_auth package + Facebook app configured in Firebase
  Future<AuthResult> signInWithFacebook() async {
    try {
      // TODO: Add flutter_facebook_auth package and implement
      return AuthFailure('Facebook Sign-In not configured. Add flutter_facebook_auth package.');
    } catch (e) {
      return AuthFailure(e.toString());
    }
  }

  /// Convert Firebase error codes to user-friendly messages
  String _getUserFriendlyMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
