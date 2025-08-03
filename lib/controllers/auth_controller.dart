// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:trafficking_detector/models/auth_model.dart';

// class AuthController {
//   static final AuthController _instance = AuthController._internal();
//   factory AuthController() => _instance;
//   AuthController._internal();

//   final SupabaseClient _supabase = Supabase.instance.client;
//   UserModel? _currentUser;

//   // Getters
//   UserModel? get currentUser => _currentUser;
//   bool get isAuthenticated => _currentUser != null;
//   SupabaseClient get supabase => _supabase;

//   // Initialize auth state on app start
//   Future<bool> initializeAuth() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final isRegistered = prefs.getBool('isRegistered') ?? false;

//       if (isRegistered) {
//         // Load user data from local storage
//         await _loadUserFromLocalStorage();
//         return true;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('Error initializing auth: $e');
//       return false;
//     }
//   }

//   // Register new user
//   Future<Map<String, dynamic>> registerUser({
//     required String firstName,
//     required String lastName,
//     required String email,
//     required String phoneNumber,
//   }) async {
//     try {
//       // Check if user already exists
//       final existingUser = await _checkUserExists(email, phoneNumber);
//       if (existingUser['exists']) {
//         return {
//           'success': false,
//           'message': existingUser['message'],
//         };
//       }

//       // Create user object (without id for insert)
//       final newUser = UserModel(
//         firstName: firstName,
//         lastName: lastName,
//         email: email,
//         phoneNumber: phoneNumber,
//       );

//       // Save to Supabase using toInsertJson to exclude id and timestamps
//       final response = await _supabase
//           .from('users')
//           .insert(newUser.toInsertJson())
//           .select()
//           .single();

//       debugPrint('Supabase response: $response');

//       // Create user model from response
//       final savedUser = UserModel.fromJson(response);

//       // Save to local storage
//       await _saveUserToLocalStorage(savedUser);

//       // Set current user
//       _currentUser = savedUser;

//       return {
//         'success': true,
//         'message': 'Registration successful',
//         'user': savedUser,
//       };
//     } on PostgrestException catch (e) {
//       debugPrint('Supabase error: ${e.message}');
//       debugPrint('Supabase error details: ${e.details}');
//       debugPrint('Supabase error hint: ${e.hint}');
//       return {
//         'success': false,
//         'message': _getReadableErrorMessage(e.message),
//       };
//     } catch (e) {
//       debugPrint('Registration error: $e');
//       return {
//         'success': false,
//         'message': 'Registration failed. Please try again.',
//       };
//     }
//   }

//   // Convert technical error messages to user-friendly messages
//   String _getReadableErrorMessage(String? errorMessage) {
//     if (errorMessage == null) return 'An unknown error occurred';

//     if (errorMessage
//         .contains('duplicate key value violates unique constraint')) {
//       if (errorMessage.contains('email')) {
//         return 'An account with this email already exists';
//       } else if (errorMessage.contains('phone')) {
//         return 'An account with this phone number already exists';
//       }
//       return 'This information is already registered';
//     }

//     if (errorMessage.contains('not-null constraint')) {
//       return 'Required information is missing';
//     }

//     if (errorMessage.contains('permission denied')) {
//       return 'Access denied. Please check your permissions';
//     }

//     return 'Registration failed. Please try again';
//   }

//   // Check if user exists by email or phone
//   Future<Map<String, dynamic>> _checkUserExists(
//       String email, String phoneNumber) async {
//     try {
//       final emailResponse = await _supabase
//           .from('users')
//           .select('id')
//           .eq('email', email)
//           .maybeSingle();

//       if (emailResponse != null) {
//         return {
//           'exists': true,
//           'message': 'An account with this email already exists',
//         };
//       }

//       final phoneResponse = await _supabase
//           .from('users')
//           .select('id')
//           .eq('phone_number', phoneNumber)
//           .maybeSingle();

//       if (phoneResponse != null) {
//         return {
//           'exists': true,
//           'message': 'An account with this phone number already exists',
//         };
//       }

//       return {'exists': false};
//     } catch (e) {
//       debugPrint('Error checking user existence: $e');
//       return {'exists': false};
//     }
//   }

//   // Save user to local storage
//   Future<void> _saveUserToLocalStorage(UserModel user) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // Save individual fields (for backward compatibility)
//       await prefs.setString('firstName', user.firstName);
//       await prefs.setString('lastName', user.lastName);
//       await prefs.setString('email', user.email);
//       await prefs.setString('phoneNumber', user.phoneNumber);
//       await prefs.setBool('isRegistered', true);

//       // Save complete user object
//       final userJson = jsonEncode(user.toLocalStorage());
//       await prefs.setString('currentUser', userJson);

//       // Save user ID separately for quick access
//       if (user.id != null) {
//         await prefs.setString('userId', user.id!);
//       }
//     } catch (e) {
//       debugPrint('Error saving user to local storage: $e');
//     }
//   }

//   // Load user from local storage
//   Future<void> _loadUserFromLocalStorage() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userJson = prefs.getString('currentUser');

//       if (userJson != null) {
//         final userData = jsonDecode(userJson);
//         _currentUser = UserModel.fromLocalStorage(userData);
//       } else {
//         // Fallback to individual fields for backward compatibility
//         final firstName = prefs.getString('firstName') ?? '';
//         final lastName = prefs.getString('lastName') ?? '';
//         final email = prefs.getString('email') ?? '';
//         final phoneNumber = prefs.getString('phoneNumber') ?? '';
//         final userId = prefs.getString('userId');

//         if (firstName.isNotEmpty && lastName.isNotEmpty) {
//           _currentUser = UserModel(
//             id: userId,
//             firstName: firstName,
//             lastName: lastName,
//             email: email,
//             phoneNumber: phoneNumber,
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint('Error loading user from local storage: $e');
//     }
//   }

//   // Update user information
//   Future<Map<String, dynamic>> updateUser({
//     String? firstName,
//     String? lastName,
//     String? email,
//     String? phoneNumber,
//   }) async {
//     try {
//       if (_currentUser == null) {
//         return {
//           'success': false,
//           'message': 'No user logged in',
//         };
//       }

//       // Create updated user object
//       final updatedUser = _currentUser!.copyWith(
//         firstName: firstName,
//         lastName: lastName,
//         email: email,
//         phoneNumber: phoneNumber,
//         updatedAt: DateTime.now(),
//       );

//       // Update in Supabase
//       final response = await _supabase
//           .from('users')
//           .update(updatedUser.toJson())
//           .eq('id', _currentUser!.id!)
//           .select()
//           .single();

//       // Update local user
//       _currentUser = UserModel.fromJson(response);

//       // Save to local storage
//       await _saveUserToLocalStorage(_currentUser!);

//       return {
//         'success': true,
//         'message': 'User updated successfully',
//         'user': _currentUser,
//       };
//     } catch (e) {
//       debugPrint('Update user error: $e');
//       return {
//         'success': false,
//         'message': 'Failed to update user: $e',
//       };
//     }
//   }

//   // Get user by ID
//   Future<UserModel?> getUserById(String userId) async {
//     try {
//       final response =
//           await _supabase.from('users').select().eq('id', userId).single();

//       return UserModel.fromJson(response);
//     } catch (e) {
//       debugPrint('Error getting user by ID: $e');
//       return null;
//     }
//   }

//   // Refresh current user data from server
//   Future<Map<String, dynamic>> refreshUserData() async {
//     try {
//       if (_currentUser?.id == null) {
//         return {
//           'success': false,
//           'message': 'No user logged in',
//         };
//       }

//       final response = await _supabase
//           .from('users')
//           .select()
//           .eq('id', _currentUser!.id!)
//           .single();

//       _currentUser = UserModel.fromJson(response);
//       await _saveUserToLocalStorage(_currentUser!);

//       return {
//         'success': true,
//         'message': 'User data refreshed',
//         'user': _currentUser,
//       };
//     } catch (e) {
//       debugPrint('Error refreshing user data: $e');
//       return {
//         'success': false,
//         'message': 'Failed to refresh user data: $e',
//       };
//     }
//   }

//   // Logout user
//   Future<void> logout() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.clear();
//       _currentUser = null;
//     } catch (e) {
//       debugPrint('Error during logout: $e');
//     }
//   }

//   // Delete user account
//   Future<Map<String, dynamic>> deleteAccount() async {
//     try {
//       if (_currentUser?.id == null) {
//         return {
//           'success': false,
//           'message': 'No user logged in',
//         };
//       }

//       await _supabase.from('users').delete().eq('id', _currentUser!.id!);

//       await logout();

//       return {
//         'success': true,
//         'message': 'Account deleted successfully',
//       };
//     } catch (e) {
//       debugPrint('Error deleting account: $e');
//       return {
//         'success': false,
//         'message': 'Failed to delete account: $e',
//       };
//     }
//   }

//   // Get all users (admin function)
//   Future<List<UserModel>> getAllUsers() async {
//     try {
//       final response = await _supabase
//           .from('users')
//           .select()
//           .order('created_at', ascending: false);

//       return response.map((json) => UserModel.fromJson(json)).toList();
//     } catch (e) {
//       debugPrint('Error getting all users: $e');
//       return [];
//     }
//   }

//   // Search users by name or email
//   Future<List<UserModel>> searchUsers(String query) async {
//     try {
//       final response = await _supabase
//           .from('users')
//           .select()
//           .or('first_name.ilike.%$query%,last_name.ilike.%$query%,email.ilike.%$query%')
//           .order('created_at', ascending: false);

//       return response.map((json) => UserModel.fromJson(json)).toList();
//     } catch (e) {
//       debugPrint('Error searching users: $e');
//       return [];
//     }
//   }
// }
