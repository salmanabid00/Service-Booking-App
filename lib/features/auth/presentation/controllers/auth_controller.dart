import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/app_user.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  
  final Rxn<User> firebaseUser = Rxn<User>();
  final Rxn<AppUser> currentUser = Rxn<AppUser>();
  final RxBool isLoading = false.obs;
  bool _hasRedirected = false;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_authService.userStream);
    
    // Listen for auth changes, but we will rely on SplashView's timer 
    // for the initial redirection to ensure it doesn't happen too fast.
    ever(firebaseUser, (user) {
      if (_hasRedirected) {
        if (user == null) {
          _handleLogout();
        } else {
          _handleLogin(user);
        }
      }
    });
  }

  // This is called by SplashView after 3 seconds
  void checkInitialScreen() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _handleLogout();
    } else {
      await _handleLogin(user);
    }
  }

  void _handleLogout() {
    _hasRedirected = true;
    if (Get.currentRoute != '/login') {
      Get.offAllNamed('/login');
    }
  }

  Future<void> _handleLogin(User user) async {
    try {
      isLoading.value = true;
      currentUser.value = await _authService.getUserData(user.uid);
      isLoading.value = false;
      
      String targetRoute = '/home'; // Default
      
      if (currentUser.value != null) {
        if (currentUser.value?.role?.toLowerCase() == 'admin') {
          targetRoute = '/admin-dashboard';
        }
        
        // Show welcome snackbar only on first redirect
        if (!_hasRedirected) {
          Get.snackbar(
            'Success',
            'Welcome back, ${currentUser.value!.name}!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        // User logged in but no data found in Firestore? 
        // Redirect to login to be safe, or stay on home.
        // Let's go to home; if they are authenticated they should see services.
        targetRoute = '/home';
      }

      _hasRedirected = true;
      if (Get.currentRoute != targetRoute) {
        Get.offAllNamed(targetRoute);
      }
    } catch (e) {
      isLoading.value = false;
      _handleLogout();
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      isLoading.value = true;
      await _authService.signUp(email, password, name);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Required Fields', 'Please enter email and password.');
      return;
    }

    try {
      isLoading.value = true;
      await _authService.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleAuthError(FirebaseAuthException e) {
    String message = e.message ?? 'Authentication failed.';
    Get.snackbar(
      'Auth Message',
      message,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  Future<void> logout() async {
    await _authService.signOut();
    // ever() will catch this and call _handleLogout()
  }
}
