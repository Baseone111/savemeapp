// Your existing ReportScreen.dart file (Update this)
// Remove the import 'dart:io'; from here since it's only needed in the repository.
// The file picker now directly gives you bytes for web and a path for native.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trafficking_detector/models/services/repositories/reportRepository.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'dart:io'; // Keep this for the `File` class if building for native, but be mindful of kIsWeb.

import 'package:trafficking_detector/screens/bloc/report_event.dart';
import 'package:trafficking_detector/screens/bloc/report_state.dart';
import 'package:trafficking_detector/screens/bloc/repot_bloc.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Initialize repository and inject into BLoC
    final supabaseClient = Supabase.instance.client;
    final reportRepository = ReportRepositoryImpl(supabaseClient);

    return BlocProvider(
      create: (_) => ReportBloc(
        reportRepository: reportRepository,
        supabaseClient: supabaseClient,
      ),
      child: Scaffold(
        backgroundColor: Color(0xfff5f6fa),
        appBar: AppBar(
          backgroundColor: Color(0xffcdbcbc),
          elevation: 0,
          title: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Logo.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Report Incident',
                style: TextStyle(
                  color: Color(0xFF1A1D29),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline, color: Color(0xFF1A1D29)),
              onPressed: () => _showHelpDialog(),
            ),
          ],
        ),
        body: BlocConsumer<ReportBloc, ReportState>(
          listener: (context, state) {
            // Show success dialog only when not loading and no error
            if (!state.isLoading &&
                state.errorMessage == null &&
                state.description.isEmpty && // Form was cleared
                state.incidentType == 'Suspicious Activity') {
              // Back to initial state
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Report Submitted Successfully'),
                  content: Text(
                      'Your report has been submitted and saved to the database. Authorities will be notified if immediate action is required.'),
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
          },
          builder: (context, state) {
            final bloc = BlocProvider.of<ReportBloc>(context);
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSafetyNotice(),
                        SizedBox(height: 20),
                        if (state.errorMessage != null)
                          _buildErrorMessage(state.errorMessage!),
                        _buildIncidentTypeSelector(state, bloc),
                        SizedBox(height: 16),
                        _buildDescriptionField(bloc),
                        SizedBox(height: 16),
                        _buildLocationField(state, bloc),
                        SizedBox(height: 16),
                        _buildAnonymousToggle(state, bloc),
                        SizedBox(height: 16),
                        _buildAttachmentSection(state, bloc),
                        SizedBox(height: 16),
                        _buildUrgencySelector(state, bloc),
                        SizedBox(height: 24),
                        _buildSubmitButton(state, bloc),
                      ],
                    ),
                  ),
                ),
                if (state.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Submitting report to database...',
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
            );
          },
        ),
      ),
    );
  }

  // Rest of your widget methods remain the same...
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

  Widget _buildSafetyNotice() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.security, color: Colors.blue[700]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Safety First',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue[800])),
                SizedBox(height: 4),
                Text('Only report when it\'s safe. All reports are encrypted.',
                    style: TextStyle(color: Colors.blue[700], height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentTypeSelector(ReportState state, ReportBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Incident Type *', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: state.incidentType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          items: [
            'Suspicious Activity',
            'Human Trafficking',
            'Forced Labor',
            'Missing Person',
            'Other',
          ]
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: (value) => bloc.add(SetIncidentType(value!)),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(ReportBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description *', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextFormField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Describe what you observed...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please provide a description' : null,
          onChanged: (value) => bloc.add(SetDescription(value)),
        ),
      ],
    );
  }

  Widget _buildLocationField(ReportState state, ReportBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextFormField(
          initialValue: state.location,
          decoration: InputDecoration(
            hintText: 'Enter location or address',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) => bloc.add(SetLocation(value)),
        ),
      ],
    );
  }

  Widget _buildAnonymousToggle(ReportState state, ReportBloc bloc) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.visibility_off, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Anonymous Report',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Your identity will not be shared',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          Switch(
            value: state.isAnonymous,
            onChanged: (value) => bloc.add(SetAnonymous(value)),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentSection(ReportState state, ReportBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Attachments', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom, // Important for web
              allowedExtensions: [
                'jpg',
                'png',
                'pdf'
              ], // Specify allowed extensions
            );

            if (result != null && result.files.single.name != null) {
              final platformFile = result.files.single;
              final filename = platformFile.name;

              if (kIsWeb) {
                // For web, directly use bytes from platformFile
                if (platformFile.bytes != null) {
                  bloc.add(AddAttachment(
                      fileBytes: platformFile.bytes!, filename: filename));
                }
              } else {
                // For native, use the path to create a File object
                if (platformFile.path != null) {
                  final file = File(platformFile.path!);
                  bloc.add(AddAttachment(file: file, filename: filename));
                }
              }
            }
          },
          icon: Icon(Icons.attach_file),
          label: Text('Add Attachment'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[100],
            foregroundColor: Colors.grey[800],
            minimumSize: Size(double.infinity, 45),
          ),
        ),
        if (state.attachedFiles.isNotEmpty) ...[
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.attachedFiles.length} file(s) attached:',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                ...state.attachedFileNames
                    .asMap()
                    .entries
                    .map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.attach_file,
                                size: 16, color: Colors.green[600]),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: TextStyle(color: Colors.green[700]),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close,
                                  size: 18, color: Colors.red[600]),
                              onPressed: () =>
                                  bloc.add(RemoveAttachment(entry.key)),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUrgencySelector(ReportState state, ReportBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Urgency Level', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _buildUrgencyChip('Low', Colors.green, state, bloc)),
            SizedBox(width: 8),
            Expanded(
                child: _buildUrgencyChip('Medium', Colors.orange, state, bloc)),
            SizedBox(width: 8),
            Expanded(child: _buildUrgencyChip('High', Colors.red, state, bloc)),
          ],
        ),
      ],
    );
  }

  Widget _buildUrgencyChip(
      String label, Color color, ReportState state, ReportBloc bloc) {
    final isSelected = state.urgencyLevel == label;
    final textColor = isSelected ? Colors.white : color; // Corrected textColor

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => bloc.add(SetUrgencyLevel(label)),
      backgroundColor: color.withOpacity(0.1),
      selectedColor: color,
      checkmarkColor: Colors.white,
    );
  }

  Widget _buildSubmitButton(ReportState state, ReportBloc bloc) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: state.isLoading ? null : () => bloc.add(SubmitReport()),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1E3A8A),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: state.isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                'Submit Report',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reporting Help'),
        content: Text(
            'Provide as much detail as possible while ensuring your safety. All reports are encrypted and handled confidentially.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }
}
