// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:trafficking_detector/models/incident_report.dart';

// String INCIDENT_COLLECTION_REF = "reportedIncidents";

// class IncidentReportService {
//   final _firestore = FirebaseFirestore.instance;
//   late final CollectionReference _incidentRef;

//   IncidentReportService() {
//     _incidentRef = _firestore
//         .collection(INCIDENT_COLLECTION_REF)
//         .withConverter<IncidentModel>(
//             fromFirestore: (snapshots, _) => IncidentModel.fromJson(
//                   snapshots.data()!,
//                 ),
//             toFirestore: (IncidentModel, _) => IncidentModel.toJson());
//   }
//   Stream<QuerySnapshot> getIncidents() {
//     return _incidentRef.snapshots();
//   }

//   void submitIncident(IncidentModel incidentModel) {
//     _incidentRef.add(incidentModel);
//   }
// }
