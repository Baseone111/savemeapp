import 'dart:io';
import 'dart:typed_data'; // Import for Uint8List
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:trafficking_detector/models/reports.dart'; // Assuming your Report model is here
import 'package:uuid/uuid.dart';

class ReportController extends ChangeNotifier {
  //final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _imagePicker = ImagePicker();
  final Uuid _uuid = Uuid();

  // Form state
  String _incidentType = 'Suspicious Activity';
  String _description = '';
  String _location = '';
  bool _isAnonymous = true;
  String _urgencyLevel = 'Low';

  // For UI display (uses dart:io.File)
  List<File> _attachedFiles = [];
  List<String> _attachedFileNames = [];

  // For actual upload (stores XFile or PlatformFile for direct byte access)
  List<dynamic> _rawPickedFiles = [];

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get incidentType => _incidentType;
  String get description => _description;
  String get location => _location;
  bool get isAnonymous => _isAnonymous;
  String get urgencyLevel => _urgencyLevel;
  List<File> get attachedFiles =>
      _attachedFiles; // This is for displaying local file paths
  List<String> get attachedFileNames => _attachedFileNames;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Setters
  void setIncidentType(String type) {
    _incidentType = type;
    notifyListeners();
  }

  void setDescription(String desc) {
    _description = desc;
    notifyListeners();
  }

  void setLocation(String loc) {
    _location = loc;
    notifyListeners();
  }

  void setAnonymous(bool anonymous) {
    _isAnonymous = anonymous;
    notifyListeners();
  }

  void setUrgencyLevel(String level) {
    _urgencyLevel = level;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Camera functionality
  Future<void> takePhoto() async {
    try {
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        _setError('Camera permission is required to take photos');
        return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        _rawPickedFiles.add(image); // Store the XFile
        _attachedFiles.add(File(image.path)); // For UI display
        _attachedFileNames.add(image.name);
        _setError(null);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to take photo: ${e.toString()}');
    }
  }

  // Image picker from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        _rawPickedFiles.add(image); // Store the XFile
        _attachedFiles.add(File(image.path)); // For UI display
        _attachedFileNames.add(image.name);
        _setError(null);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to pick image: ${e.toString()}');
    }
  }

  // File picker
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final platformFile = result.files.single; // Get the PlatformFile

        _rawPickedFiles.add(platformFile); // Store the PlatformFile
        _attachedFiles.add(File(platformFile.path!)); // For UI display
        _attachedFileNames.add(platformFile.name);
        _setError(null);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to pick file: ${e.toString()}');
    }
  }

  // Remove attached file
  void removeAttachedFile(int index) {
    if (index >= 0 && index < _attachedFiles.length) {
      _attachedFiles.removeAt(index);
      _attachedFileNames.removeAt(index);
      _rawPickedFiles.removeAt(index); // Remove from the raw list too!
      notifyListeners();
    }
  }

  // Upload files to Supabase Storage - ACCEPTS BYTES
  // Future<String?> _uploadFile(Uint8List fileBytes, String fileName) async {
  //   try {
  //     final fileExtension = fileName.split('.').last;
  //     final uniqueFileName = '${_uuid.v4()}.$fileExtension';
  //     final filePath = 'reports/$uniqueFileName';

  //     await _supabase.storage.from('attachments').uploadBinary(
  //           filePath,
  //           fileBytes,
  //           fileOptions: const FileOptions(
  //             cacheControl: '3600',
  //             upsert: false,
  //           ),
  //         );

  //     final String publicUrl =
  //         _supabase.storage.from('attachments').getPublicUrl(filePath);

  //     return publicUrl;
  //   // } on StorageException catch (e) {
  //   //   print('Supabase Storage Error uploading file: ${e.message}');
  //   //   _setError('Failed to upload attachment: ${e.message}');
  //   //   return null;
  //   // } catch (e) {
  //   //   print('Error uploading file: $e');
  //   //   _setError('Failed to upload attachment: ${e.toString()}');
  //   //   return null;
  //   // }
  // }

  // Determine agency level based on incident type and urgency
  String _determineAgencyLevel() {
    if (_incidentType == 'Human Trafficking' || _urgencyLevel == 'High') {
      return 'National';
    } else if (_incidentType == 'Missing Person' || _urgencyLevel == 'Medium') {
      return 'Regional';
    } else {
      return 'Local';
    }
  }

  // Submit report to Supabase
  Future<bool> submitReport() async {
    try {
      _setLoading(true);
      _setError(null);

      // Validate required fields
      if (_description.trim().isEmpty) {
        _setError('Description is required');
        _setLoading(false);
        return false;
      }

      // final user = _supabase.auth.currentUser;
      // String userIdToUse = 'anonymous';
      // if (user != null) {
      //   userIdToUse = user.id;
      // }

      // Upload attachments if any
      String? attachmentUrl;
      if (_rawPickedFiles.isNotEmpty) {
        // Use _rawPickedFiles for upload source
        final dynamic pickedObject =
            _rawPickedFiles.first; // XFile or PlatformFile
        final firstFileName = _attachedFileNames.first;

        Uint8List fileBytes;
        if (pickedObject is XFile) {
          fileBytes = await pickedObject.readAsBytes(); // Read bytes from XFile
        } else if (pickedObject is PlatformFile) {
          if (pickedObject.bytes == null) {
            // Check if bytes are already available
            // If bytes are null, it means the file is large and needs to be read from path
            // This is where the File(path).readAsBytes() would come in, but it's often the source of error
            // For now, let's assume bytes are available or prefer small files
            _setError(
                'Failed to get file bytes from PlatformFile. File might be too large or not directly accessible.');
            _setLoading(false);
            return false;
          }
          fileBytes = pickedObject.bytes!; // Direct bytes from PlatformFile
        } else {
          _setError('Unsupported file type for upload (internal error).');
          _setLoading(false);
          return false;
        }

        //attachmentUrl = await _uploadFile(fileBytes, firstFileName);

        if (attachmentUrl == null) {
          _setLoading(false);
          return false;
        }
      }

      // Create report object
      // final report = Report(
      //   id: _uuid.v4(),
      //   //userId: userIdToUse,
      //   incidentType: _incidentType,
      //   description: _description.trim(),
      //   location: _location.trim().isEmpty ? null : _location.trim(),
      //   isAnonymous: _isAnonymous,
      //   attachmentUrl: attachmentUrl,
      //   agencyLevel: _determineAgencyLevel(),
      //   createdAt: DateTime.now(),
      // );

      // Insert into Supabase
      //await _supabase.from('reports').insert(report.toJson());

      // Clear form data
      // _clearForm();

      _setLoading(false);
      return true;
      // } on PostgrestException catch (e) {
      //   print('Supabase Database Error: ${e.message}');
      //   _setError('Failed to submit report: ${e.message}');
      //   _setLoading(false);
      //   return false;
    } catch (e) {
      print(
          'Error caught in submitReport: ${e.toString()}'); // More general catch for debugging
      _setError('Failed to submit report: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Clear form data
  void _clearForm() {
    _incidentType = 'Suspicious Activity';
    _description = '';
    _location = '';
    _isAnonymous = true;
    _urgencyLevel = 'Low';
    _attachedFiles.clear();
    _attachedFileNames.clear();
    _rawPickedFiles.clear(); // Clear the raw list as well
    notifyListeners();
  }

  // Show attachment options
  void showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  takePhoto();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text('Attach File'),
                onTap: () {
                  Navigator.pop(context);
                  pickFile();
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
