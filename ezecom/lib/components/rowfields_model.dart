import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'rowfields_widget.dart' show RowfieldsWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RowfieldsModel extends FlutterFlowModel<RowfieldsWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for FeautureTextField widget.
  FocusNode? feautureTextFieldFocusNode;
  TextEditingController? feautureTextFieldTextController;
  String? Function(BuildContext, String?)?
      feautureTextFieldTextControllerValidator;
  // State field(s) for ValueTextField widget.
  FocusNode? valueTextFieldFocusNode;
  TextEditingController? valueTextFieldTextController;
  String? Function(BuildContext, String?)?
      valueTextFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    feautureTextFieldFocusNode?.dispose();
    feautureTextFieldTextController?.dispose();

    valueTextFieldFocusNode?.dispose();
    valueTextFieldTextController?.dispose();
  }
}
