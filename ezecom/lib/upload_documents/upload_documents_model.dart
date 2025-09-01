import '/components/document_upload_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'upload_documents_widget.dart' show UploadDocumentsWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class UploadDocumentsModel extends FlutterFlowModel<UploadDocumentsWidget> {
  ///  Local state fields for this page.

  List<String> documentFields = [];
  void addToDocumentFields(String item) => documentFields.add(item);
  void removeFromDocumentFields(String item) => documentFields.remove(item);
  void removeAtIndexFromDocumentFields(int index) =>
      documentFields.removeAt(index);
  void insertAtIndexInDocumentFields(int index, String item) =>
      documentFields.insert(index, item);
  void updateDocumentFieldsAtIndex(int index, Function(String) updateFn) =>
      documentFields[index] = updateFn(documentFields[index]);

  bool visiblity = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getUserRole4] action in UploadDocuments widget.
  String? role;
  // Stores action output result for [Custom Action - checkRejectionsByRole] action in UploadDocuments widget.
  bool? rejectionStatus;
  // Stores action output result for [Custom Action - updateDocumentstoSupabaseBuyer] action in Button widget.
  bool? buyerDocuploadStatus;
  // Stores action output result for [Custom Action - updateDocumentstoSupabaseSeller] action in Button widget.
  bool? updateDoc;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
