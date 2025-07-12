import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

/// Firebase Configuration and Service
class FirebaseService {
  static FirebaseApp? _app;
  static FirebaseAuth? _auth;
  static GoogleSignIn? _googleSignIn;

  /// Firebase Configuration
  static const FirebaseOptions _firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyCUp0tGKJ1EWAyMJPB2GLKobX7cxf6ZKMI",
    authDomain: "ai-cv-maker-e51cb.firebaseapp.com",
    projectId: "ai-cv-maker-e51cb",
    storageBucket: "ai-cv-maker-e51cb.firebasestorage.app",
    messagingSenderId: "31886727213",
    appId: "1:31886727213:web:2080f5352525bffe7380a4",
    measurementId: "G-Y2G3W2X68P",
  );

  /// Initialize Firebase
  static Future<void> initialize() async {
    try {
      _app = await Firebase.initializeApp(
        options: _firebaseOptions,
      );
      _auth = FirebaseAuth.instance;
      _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
      rethrow;
    }
  }

  /// Get Firebase Auth instance
  static FirebaseAuth get auth {
    if (_auth == null) {
      throw Exception('Firebase not initialized. Call FirebaseService.initialize() first.');
    }
    return _auth!;
  }

  /// Get Google Sign In instance
  static GoogleSignIn get googleSignIn {
    if (_googleSignIn == null) {
      throw Exception('Firebase not initialized. Call FirebaseService.initialize() first.');
    }
    return _googleSignIn!;
  }

  /// Get current user
  static User? get currentUser => _auth?.currentUser;

  /// Check if user is signed in
  static bool get isSignedIn => currentUser != null;

  /// Sign in with email and password
  static Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Email sign in error: ${e.message}');
      rethrow;
    }
  }

  /// Sign up with email and password
  static Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Email sign up error: ${e.message}');
      rethrow;
    }
  }

  /// Sign in with Google
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Google sign in error: $e');
      rethrow;
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await Future.wait([
        auth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }

  /// Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.message}');
      rethrow;
    }
  }

  /// Listen to auth state changes
  static Stream<User?> get authStateChanges => auth.authStateChanges();
}
