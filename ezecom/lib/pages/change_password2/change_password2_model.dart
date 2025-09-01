import '/auth/supabase_auth/auth_util.dart';
import '/components/add_product_failed_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'change_password2_widget.dart' show ChangePassword2Widget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChangePassword2Model extends FlutterFlowModel<ChangePassword2Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for newPasswordd widget.
  FocusNode? newPassworddFocusNode;
  TextEditingController? newPassworddTextController;
  late bool newPassworddVisibility;
  String? Function(BuildContext, String?)? newPassworddTextControllerValidator;
  // State field(s) for confirmPassword widget.
  FocusNode? confirmPasswordFocusNode;
  TextEditingController? confirmPasswordTextController;
  late bool confirmPasswordVisibility;
  String? Function(BuildContext, String?)?
      confirmPasswordTextControllerValidator;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel;

  @override
  void initState(BuildContext context) {
    newPassworddVisibility = false;
    confirmPasswordVisibility = false;
    addProductFailedModel = createModel(context, () => AddProductFailedModel());
  }

  @override
  void dispose() {
    newPassworddFocusNode?.dispose();
    newPassworddTextController?.dispose();

    confirmPasswordFocusNode?.dispose();
    confirmPasswordTextController?.dispose();

    addProductFailedModel.dispose();
  }
}
