// packages/trafficking_detector/models/services/repositories/reportRepository.dart (Update this file)

import 'dart:io';
import 'dart:typed_data'; // Import for Uint8List
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trafficking_detector/core/errors/exception.dart';
import 'package:trafficking_detector/models/incident_reportModel.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb

abstract interface class ReportRepository {
  Future<void> submitReport(ReportModel report,
      {File? attachment,
      Uint8List? attachmentBytes,
      String? attachmentFileName});
}

class ReportRepositoryImpl implements ReportRepository {
  final SupabaseClient supabaseClient;

  ReportRepositoryImpl(this.supabaseClient);

  @override
  Future<void> submitReport(ReportModel report,
      {File? attachment,
      Uint8List? attachmentBytes,
      String? attachmentFileName}) async {
    try {
      String? attachmentUrl;

      // Upload file if provided
      if (attachment != null || attachmentBytes != null) {
        try {
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          String fileExtension = 'file';

          if (attachmentFileName != null) {
            fileExtension = attachmentFileName.split('.').last.toLowerCase();
          } else if (attachment != null) {
            fileExtension = attachment.path.split('.').last.toLowerCase();
          }

          final fileName = 'attachments/${timestamp}_attachment.$fileExtension';

          print('Uploading file: $fileName');

          // Determine the bytes to upload based on platform
          Uint8List? fileData;
          if (kIsWeb) {
            fileData = attachmentBytes;
          } else {
            if (attachment != null) {
              fileData = await attachment.readAsBytes();
            }
          }

          if (fileData == null) {
            throw ServerException('File data is null, cannot upload.');
          }

          print('File size: ${fileData.length} bytes');

          final uploadResponse =
              await supabaseClient.storage.from('attachments').uploadBinary(
                    fileName,
                    fileData,
                    fileOptions: const FileOptions(
                      cacheControl: '3600',
                      upsert: false,
                    ),
                  );

          print('Upload response: $uploadResponse');

          attachmentUrl =
              supabaseClient.storage.from('attachments').getPublicUrl(fileName);

          print('Attachment URL: $attachmentUrl');
        } catch (fileError) {
          print('File handling error: $fileError');
          throw ServerException('File upload failed: $fileError');
        }
      }

      print('Submitting report with data: ${report.toJson()}');

      // Insert report data into the database
      // The `upsert` option for insert is typically not used for new inserts unless you want to update existing rows on conflict.
      // For inserting new reports, just `insert` is sufficient.
      final response = await supabaseClient.from('trafficking_reports').insert({
        'incident_type': report.incidentType,
        'description': report.description,
        'location': report.location,
        'anonymous': report.anonymous,
        'created_at': report.reportedAt.toIso8601String(),
        'evidence_url': attachmentUrl,
        'user_id': report.userId,
        'urgency_level': report.urgencyLevel, // Add urgency_level
      });

      print('Report submitted successfully: $response');
    } on StorageException catch (e) {
      print('Storage error: ${e.message}');
      throw ServerException('File upload failed: ${e.message}');
    } on PostgrestException catch (e) {
      print('Database error: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e, stackTrace) {
      print('Unexpected error: $e');
      print('Error type: ${e.runtimeType}');
      print('Stack trace: $stackTrace');
      throw ServerException('Failed to submit report: $e');
    }
  }
}
