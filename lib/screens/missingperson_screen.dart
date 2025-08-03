// lib/screens/missing_person_screen.dart (or wherever your file is located)
import 'dart:io';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart'; // For photo selection
import 'package:file_picker/file_picker.dart'; // For file selection
import 'package:permission_handler/permission_handler.dart'; // For permission requests
// For location
import 'package:intl/intl.dart'; // For date formatting
import 'package:supabase_flutter/supabase_flutter.dart'; // For Supabase client
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:trafficking_detector/models/services/repositories/misPersonRepo.dart';
// For platform detection // Import your new repository

class MissingPersonScreen extends StatefulWidget {
  @override
  _MissingPersonScreenState createState() => _MissingPersonScreenState();
}

class _MissingPersonScreenState extends State<MissingPersonScreen> {
  final _formKey = GlobalKey<FormState>();
  final MissingPersonRepository _missingPersonRepository =
      MissingPersonRepositoryImpl(
          Supabase.instance.client); // Initialize repository

  String _name = '';
  String _age = '';
  String _description = '';
  String _lastSeen = '';
  String _relationship = '';
  File? _photo; // For displaying on native
  Uint8List? _photoBytes; // For uploading (web and native)
  String? _photoFileName; // File name for upload
  TextEditingController _dateTimeController =
      TextEditingController(); // For date/time picker
  TextEditingController _locationController =
      TextEditingController(); // For location field

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _dateTimeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _setErrorMessage(String? message) {
    setState(() {
      _errorMessage = message;
    });
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f6f8),
      appBar: AppBar(
        backgroundColor: Color(0xffcdbcbc),
        elevation: 0,
        title: Row(
          children: [
            Container(
              height: 60,
              width: 80,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Logo.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Report Missing',
              style: TextStyle(
                color: Color(0xFF1A1D29),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null) _buildErrorMessage(_errorMessage!),
                  _buildPhotoSection(),
                  SizedBox(height: 20),
                  _buildPersonalInfoSection(),
                  SizedBox(height: 20),
                  _buildLastSeenSection(),
                  SizedBox(height: 20),
                  _buildRelationshipSection(),
                  SizedBox(height: 24),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Submitting report...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photo *',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPhotoSelectionOptions(),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[100],
            ),
            child: _photo != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(_photo!, fit: BoxFit.cover),
                  )
                : (_photoBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(_photoBytes!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo,
                              size: 48, color: Colors.grey[600]),
                          SizedBox(height: 8),
                          Text('Tap to add photo',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      )),
          ),
        ),
        if (_photoFileName != null) ...[
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Selected: $_photoFileName',
                  style: TextStyle(color: Colors.grey[700]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18),
                onPressed: () {
                  setState(() {
                    _photo = null;
                    _photoBytes = null;
                    _photoFileName = null;
                  });
                },
              )
            ],
          )
        ],
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Personal Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 12),
        _buildInputField(
            label: 'Full Name *',
            onSaved: (v) => _name = v!,
            validatorMsg: 'Please enter the person\'s name'),
        SizedBox(height: 16),
        _buildInputField(
            label: 'Age',
            keyboardType: TextInputType.number,
            onSaved: (v) => _age = v!),
        SizedBox(height: 16),
        _buildInputField(
          label: 'Physical Description',
          hint: 'Height, weight, hair color, clothing, etc.',
          maxLines: 3,
          onSaved: (v) => _description = v!,
        ),
      ],
    );
  }

  Widget _buildLastSeenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last Seen Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 12),
        _buildInputField(
          label: 'Last Seen Location *',
          controller: _locationController, // Bind controller
          onSaved: (v) => _lastSeen = v!,
          validatorMsg: 'Please enter last seen location',
          suffixIcon: IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () => _getCurrentLocation(),
          ),
        ),
        SizedBox(height: 16),
        _buildInputField(
          label: 'Date & Time Last Seen',
          readOnly: true,
          controller: _dateTimeController, // Bind controller
          onTap: () => _selectDateTime(context),
          suffixIcon: Icon(Icons.calendar_today),
          onSaved: (value) =>
              _dateTimeController.text = value ?? '', // Use controller for save
        ),
      ],
    );
  }

  Widget _buildRelationshipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Relationship',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Relationship to Missing Person *',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          items: [
            'Family Member',
            'Friend',
            'Colleague',
            'Neighbor',
            'Other',
          ]
              .map((relationship) => DropdownMenuItem(
                    value: relationship,
                    child: Text(relationship),
                  ))
              .toList(),
          validator: (value) =>
              value == null ? 'Please select your relationship' : null,
          onChanged: (value) => setState(() => _relationship = value ?? ''),
          onSaved: (value) =>
              _relationship = value ?? '', // Ensure value is saved
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _submitMissingPersonReport(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFEB4C09),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                'Submit Missing Person Report',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    Widget? suffixIcon,
    String? validatorMsg,
    required FormFieldSetter<String> onSaved,
    VoidCallback? onTap,
    TextEditingController? controller, // Add controller parameter
  }) {
    return TextFormField(
      controller: controller, // Assign controller
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: validatorMsg != null
          ? (value) => value?.isEmpty ?? true ? validatorMsg : null
          : null,
      onSaved: onSaved,
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPhotoSelectionOptions() async {
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
                  _takePhoto();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text('Attach File'), // For other file types
                onTap: () {
                  Navigator.pop(context);
                  _pickFile();
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

  Future<void> _takePhoto() async {
    try {
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        _setErrorMessage('Camera permission is required to take photos');
        return;
      }

      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _photoBytes = bytes;
          _photoFileName = image.name;
          if (!kIsWeb) {
            _photo = File(image.path); // Only for native platforms
          }
        });
        _setErrorMessage(null);
      }
    } catch (e) {
      _setErrorMessage('Failed to take photo: ${e.toString()}');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _photoBytes = bytes;
          _photoFileName = image.name;
          if (!kIsWeb) {
            _photo = File(image.path); // Only for native platforms
          }
        });
        _setErrorMessage(null);
      }
    } catch (e) {
      _setErrorMessage('Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType
            .image, // Restrict to image types for consistency with _photo
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        final platformFile = result.files.single;
        setState(() {
          _photoBytes = platformFile.bytes;
          _photoFileName = platformFile.name;
          if (!kIsWeb && platformFile.path != null) {
            _photo =
                File(platformFile.path!); // Only for native platforms with path
          }
        });
        _setErrorMessage(null);
      } else if (result != null &&
          result.files.single.path != null &&
          !kIsWeb) {
        // Fallback for native where bytes might not be directly available for very large files
        final file = File(result.files.single.path!);
        final bytes = await file.readAsBytes();
        setState(() {
          _photoBytes = bytes;
          _photoFileName = result.files.single.name;
          _photo = file;
        });
        _setErrorMessage(null);
      }
    } catch (e) {
      _setErrorMessage('Failed to pick file: ${e.toString()}');
    }
  }

  Future<void> _getCurrentLocation() async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setErrorMessage('Location permissions are denied.');
          _setLoading(false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _setErrorMessage(
            'Location permissions are permanently denied, we cannot request permissions.');
        _setLoading(false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // In a real app, you'd convert lat/long to a readable address using geocoding
      // For simplicity, we'll just put the coordinates
      setState(() {
        _locationController.text =
            '${position.latitude}, ${position.longitude}';
        _lastSeen = _locationController.text; // Update saved value
      });
      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Could not get current location: ${e.toString()}');
      _setLoading(false);
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _dateTimeController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(fullDateTime);
        });
      }
    }
  }

  Future<void> _submitMissingPersonReport() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      _setLoading(true);
      _setErrorMessage(null);

      // Validate photo is selected
      if (_photoBytes == null) {
        _setErrorMessage('Please select a photo of the missing person.');
        _setLoading(false);
        return;
      }

      try {
        bool success = await _missingPersonRepository.submitMissingPersonReport(
          name: _name,
          age: _age,
          description: _description,
          lastSeenLocation: _lastSeen,
          last_seen: _dateTimeController.text.isNotEmpty
              ? _dateTimeController.text
              : null,
          relationship: _relationship,
          photoBytes: _photoBytes,
          photoFileName: _photoFileName,
        );

        _setLoading(false);

        if (success) {
          _showSuccessDialog();
          _clearForm();
        } else {
          // This else block might be redundant if repository throws on failure
          _setErrorMessage('Failed to submit report. Please try again.');
        }
      } on ServerException catch (e) {
        print('Caught ServerException: ${e.message}');
        _setErrorMessage(e.message);
        _setLoading(false);
      } catch (e) {
        print('Caught general exception: ${e.toString()}');
        _setErrorMessage('An unexpected error occurred: ${e.toString()}');
        _setLoading(false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Submitted'),
        content: Text(
            'Missing person report has been submitted. Authorities and the community will be alerted.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    setState(() {
      _name = '';
      _age = '';
      _description = '';
      _lastSeen = '';
      _relationship = '';
      _photo = null;
      _photoBytes = null;
      _photoFileName = null;
      _dateTimeController.clear();
      _locationController.clear();
      _formKey.currentState?.reset(); // Resets the form fields
      _errorMessage = null;
    });
  }
}
