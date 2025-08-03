// models/services/repositories/missingPersonRepository.dart
import 'dart:typed_data'; // For Uint8List
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trafficking_detector/models/mPerson_model.dart';
import 'package:uuid/uuid.dart';
// Import your MissingPerson model

abstract class MissingPersonRepository {
  Future<bool> submitMissingPersonReport({
    required String name,
    required String age,
    required String description,
    required String lastSeenLocation,
    String? last_seen,
    required String relationship,
    Uint8List? photoBytes,
    String? photoFileName,
  });
}

class MissingPersonRepositoryImpl implements MissingPersonRepository {
  final SupabaseClient _supabase;
  final Uuid _uuid;

  MissingPersonRepositoryImpl(this._supabase) : _uuid = Uuid();

  /// Uploads a file to Supabase Storage and returns its public URL.
  Future<String?> _uploadFile(Uint8List fileBytes, String fileName) async {
    try {
      print('Attempting to upload file: $fileName');
      print('File size: ${fileBytes.length} bytes');

      final fileExtension = fileName.split('.').last;
      final uniqueFileName =
          '${_uuid.v4()}_attachment.$fileExtension'; // Ensure unique name
      final filePath =
          'missing_photos/$uniqueFileName'; // Use a dedicated folder within the bucket

      // The uploadBinary method directly returns the path on success.
      // It will throw a StorageException on failure.
      final String uploadedPath =
          await _supabase.storage.from('missingpersonphotos').uploadBinary(
                filePath,
                fileBytes,
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: false, // Don't overwrite existing files
                ),
              );

      // If uploadedPath is not null or empty, it means success
      if (uploadedPath.isNotEmpty) {
        final String publicUrl = _supabase.storage
            .from('missingpersonphotos')
            .getPublicUrl(uploadedPath); // Use the returned uploadedPath
        print('Successfully uploaded to path: $uploadedPath');
        print('Public Photo URL: $publicUrl');
        return publicUrl;
      } else {
        // This case should ideally be covered by a StorageException,
        // but as a fallback, if an empty path is returned, consider it a failure.
        print(
            'Upload completed but returned an empty path. This is unexpected.');
        return null;
      }
    } on StorageException catch (e) {
      print(
          'Supabase Storage Error uploading file: ${e.message} (statusCode: ${e.statusCode})');
      // Re-throw as a custom exception for consistent handling in submitMissingPersonReport
      throw ServerException(message: e.message, errorType: 'StorageException');
    } catch (e) {
      print('General error during file upload: ${e.toString()}');
      throw ServerException(
          message: e.toString(), errorType: 'UnknownFileUploadError');
    }
  }

  @override
  Future<bool> submitMissingPersonReport({
    required String name,
    required String age,
    required String description,
    required String lastSeenLocation,
    String? last_seen,
    required String relationship,
    Uint8List? photoBytes,
    String? photoFileName,
  }) async {
    try {
      String? photoUrl;
      if (photoBytes != null && photoFileName != null) {
        photoUrl = await _uploadFile(photoBytes, photoFileName);
        if (photoUrl == null) {
          throw ServerException(
              message: 'Failed to upload missing person photo.',
              errorType: 'PhotoUploadFailed');
        }
      }

      final currentUser = _supabase.auth.currentUser;
      final user_id = currentUser?.id;

      final missingPerson = MissingPerson(
        name: name,
        age: age,
        description: description,
        lastSeenLocation: lastSeenLocation,
        last_seen: last_seen,
        relationship: relationship,
        photoUrl: photoUrl,
        user_id: user_id,
      );

      print(
          'Submitting missing person report with data: ${missingPerson.toJson()}');

      final response = await _supabase
          .from(
              'missing_person_reports') // Assuming your table is named 'missing_persons'
          .insert(missingPerson.toJson())
          .select(); // Use .select() to get the inserted row back, or just .execute()

      print('Supabase insert response: $response');

      return true;
    } on PostgrestException catch (e) {
      print('Database error: ${e.message}');
      throw ServerException(
          message: e.message, errorType: 'PostgrestException');
    } catch (e) {
      print('Unexpected error during report submission: $e');
      throw ServerException(message: e.toString(), errorType: 'Unknown');
    }
  }
}

// Custom Exception for better error handling
class ServerException implements Exception {
  final String message;
  final String errorType;
  ServerException({required this.message, required this.errorType});

  @override
  String toString() {
    return 'Error type: $errorType\nMessage: $message';
  }
}
