// packages/trafficking_detector/screens/bloc/report_event.dart (Update or create this)

import 'dart:typed_data'; // Import for Uint8List

import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class SetIncidentType extends ReportEvent {
  final String incidentType;
  const SetIncidentType(this.incidentType);
  @override
  List<Object> get props => [incidentType];
}

class SetDescription extends ReportEvent {
  final String description;
  const SetDescription(this.description);
  @override
  List<Object> get props => [description];
}

class SetLocation extends ReportEvent {
  final String location;
  const SetLocation(this.location);
  @override
  List<Object> get props => [location];
}

class SetAnonymous extends ReportEvent {
  final bool isAnonymous;
  const SetAnonymous(this.isAnonymous);
  @override
  List<Object> get props => [isAnonymous];
}

// MODIFIED: Use Uint8List for web, and File for native
class AddAttachment extends ReportEvent {
  final File? file; // For native
  final Uint8List? fileBytes; // For web
  final String filename;

  const AddAttachment({this.file, this.fileBytes, required this.filename})
      : assert(file != null || fileBytes != null,
            'Either file or fileBytes must be provided');

  @override
  List<Object> get props => [file ?? '', fileBytes ?? '', filename];
}

class RemoveAttachment extends ReportEvent {
  final int index;
  const RemoveAttachment(this.index);
  @override
  List<Object> get props => [index];
}

class SetUrgencyLevel extends ReportEvent {
  final String urgencyLevel;
  const SetUrgencyLevel(this.urgencyLevel);
  @override
  List<Object> get props => [urgencyLevel];
}

class SubmitReport extends ReportEvent {}

class ResetForm extends ReportEvent {}
