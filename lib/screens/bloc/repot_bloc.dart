// packages/trafficking_detector/screens/bloc/repot_bloc.dart (Update this file)

import 'dart:async';
import 'dart:io';
import 'dart:typed_data'; // Import for Uint8List
import 'package:bloc/bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trafficking_detector/core/errors/exception.dart';
import 'package:trafficking_detector/models/incident_reportModel.dart';
import 'package:trafficking_detector/models/services/repositories/reportRepository.dart';
import 'package:trafficking_detector/screens/bloc/report_event.dart';
import 'package:trafficking_detector/screens/bloc/report_state.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;
  final SupabaseClient supabaseClient;

  ReportBloc({
    required this.reportRepository,
    required this.supabaseClient,
  }) : super(const ReportState()) {
    on<SetIncidentType>(_onSetIncidentType);
    on<SetDescription>(_onSetDescription);
    on<SetLocation>(_onSetLocation);
    on<SetAnonymous>(_onSetAnonymous);
    on<AddAttachment>(_onAddAttachment);
    on<RemoveAttachment>(_onRemoveAttachment);
    on<SetUrgencyLevel>(_onSetUrgencyLevel);
    on<SubmitReport>(_handleSubmit);
    on<ResetForm>(_onResetForm);
  }

  void _onSetIncidentType(SetIncidentType event, Emitter<ReportState> emit) {
    emit(state.copyWith(incidentType: event.incidentType));
  }

  void _onSetDescription(SetDescription event, Emitter<ReportState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onSetLocation(SetLocation event, Emitter<ReportState> emit) {
    emit(state.copyWith(location: event.location));
  }

  void _onSetAnonymous(SetAnonymous event, Emitter<ReportState> emit) {
    emit(state.copyWith(isAnonymous: event.isAnonymous));
  }

  void _onAddAttachment(AddAttachment event, Emitter<ReportState> emit) {
    final updatedFiles = List<dynamic>.from(state.attachedFiles);
    final updatedFileNames = List<String>.from(state.attachedFileNames);

    if (event.file != null) {
      updatedFiles.add(event.file!);
    } else if (event.fileBytes != null) {
      updatedFiles.add(event.fileBytes!);
    }
    updatedFileNames.add(event.filename);

    emit(state.copyWith(
      attachedFiles: updatedFiles,
      attachedFileNames: updatedFileNames,
    ));
  }

  void _onRemoveAttachment(RemoveAttachment event, Emitter<ReportState> emit) {
    final updatedFiles = List<dynamic>.from(state.attachedFiles);
    final updatedFileNames = List<String>.from(state.attachedFileNames);

    if (event.index >= 0 && event.index < updatedFiles.length) {
      updatedFiles.removeAt(event.index);
      updatedFileNames.removeAt(event.index);
    }

    emit(state.copyWith(
      attachedFiles: updatedFiles,
      attachedFileNames: updatedFileNames,
    ));
  }

  void _onSetUrgencyLevel(SetUrgencyLevel event, Emitter<ReportState> emit) {
    emit(state.copyWith(urgencyLevel: event.urgencyLevel));
  }

  Future<void> _handleSubmit(
      SubmitReport event, Emitter<ReportState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      String? userId;
      try {
        userId = supabaseClient.auth.currentUser?.id;
      } catch (e) {
        print('Error getting user ID: $e');
        // Continue without user ID if it cannot be retrieved
      }

      final report = ReportModel(
        incidentType: state.incidentType,
        description: state.description,
        location: state.location,
        anonymous: state.isAnonymous,
        reportedAt: DateTime.now(),
        userId: userId,
        urgencyLevel: state.urgencyLevel,
      );

      File? fileAttachment;
      Uint8List? fileBytesAttachment;

      if (state.attachedFiles.isNotEmpty) {
        if (kIsWeb) {
          // For web, attachedFiles will contain Uint8List
          fileBytesAttachment = state.attachedFiles.first as Uint8List;
        } else {
          // For native, attachedFiles will contain File
          fileAttachment = state.attachedFiles.first as File;
        }
      }

      await reportRepository.submitReport(
        report,
        attachment: fileAttachment,
        attachmentBytes: fileBytesAttachment,
        attachmentFileName: state.attachedFileNames.isNotEmpty
            ? state.attachedFileNames.first
            : null,
      );

      emit(const ReportState()); // Reset form to initial state on success
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: 'An unexpected error occurred: $e'));
    }
  }

  void _onResetForm(ResetForm event, Emitter<ReportState> emit) {
    emit(const ReportState());
  }
}
