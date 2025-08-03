// packages/trafficking_detector/screens/bloc/report_state.dart (Update or create this)

import 'dart:io';
import 'dart:typed_data'; // Import for Uint8List

import 'package:equatable/equatable.dart';

class ReportState extends Equatable {
  final String incidentType;
  final String description;
  final String location;
  final bool isAnonymous;
  final List<dynamic> attachedFiles; // Can be File or Uint8List
  final List<String> attachedFileNames;
  final String urgencyLevel;
  final bool isLoading;
  final String? errorMessage;

  const ReportState({
    this.incidentType = 'Suspicious Activity',
    this.description = '',
    this.location = '',
    this.isAnonymous = false,
    this.attachedFiles = const [],
    this.attachedFileNames = const [],
    this.urgencyLevel = 'Medium',
    this.isLoading = false,
    this.errorMessage,
  });

  ReportState copyWith({
    String? incidentType,
    String? description,
    String? location,
    bool? isAnonymous,
    List<dynamic>? attachedFiles, // Can be File or Uint8List
    List<String>? attachedFileNames,
    String? urgencyLevel,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReportState(
      incidentType: incidentType ?? this.incidentType,
      description: description ?? this.description,
      location: location ?? this.location,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      attachedFiles: attachedFiles ?? this.attachedFiles,
      attachedFileNames: attachedFileNames ?? this.attachedFileNames,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        incidentType,
        description,
        location,
        isAnonymous,
        attachedFiles,
        attachedFileNames,
        urgencyLevel,
        isLoading,
        errorMessage,
      ];
}
