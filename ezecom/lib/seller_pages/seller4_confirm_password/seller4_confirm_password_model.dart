import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/confirm_dialouge_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'seller4_confirm_password_widget.dart' show Seller4ConfirmPasswordWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class Seller4ConfirmPasswordModel
    extends FlutterFlowModel<Seller4ConfirmPasswordWidget> {
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

  @override
  void initState(BuildContext context) {
    newPassworddVisibility = false;
    confirmPasswordVisibility = false;
  }

  @override
  void dispose() {
    newPassworddFocusNode?.dispose();
    newPassworddTextController?.dispose();

    confirmPasswordFocusNode?.dispose();
    confirmPasswordTextController?.dispose();
  }
}
