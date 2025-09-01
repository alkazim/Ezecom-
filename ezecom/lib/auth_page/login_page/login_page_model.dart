import '/auth/supabase_auth/auth_util.dart';
import '/components/no_account_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'login_page_widget.dart' show LoginPageWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class LoginPageModel extends FlutterFlowModel<LoginPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for EmailFieldL widget.
  FocusNode? emailFieldLFocusNode;
  TextEditingController? emailFieldLTextController;
  String? Function(BuildContext, String?)? emailFieldLTextControllerValidator;
  // State field(s) for PasswordFieldL widget.
  FocusNode? passwordFieldLFocusNode;
  TextEditingController? passwordFieldLTextController;
  late bool passwordFieldLVisibility;
  String? Function(BuildContext, String?)?
      passwordFieldLTextControllerValidator;
  // State field(s) for EmailFieldT widget.
  FocusNode? emailFieldTFocusNode;
  TextEditingController? emailFieldTTextController;
  String? Function(BuildContext, String?)? emailFieldTTextControllerValidator;
  // State field(s) for PasswordFieldT widget.
  FocusNode? passwordFieldTFocusNode;
  TextEditingController? passwordFieldTTextController;
  late bool passwordFieldTVisibility;
  String? Function(BuildContext, String?)?
      passwordFieldTTextControllerValidator;
  // Stores action output result for [Custom Action - getTopDealProductIDs] action in Container widget.
  List<int>? dTDids;
  // Stores action output result for [Custom Action - getFeaturedOfferProductIDs] action in Container widget.
  List<int>? dFOids;
  // Stores action output result for [Custom Action - getNewArrivalProductIDs] action in Container widget.
  List<int>? dNAids;
  // Stores action output result for [Custom Action - getTopDealProductIDs] action in IconButton widget.
  List<int>? dTDids1;
  // Stores action output result for [Custom Action - getFeaturedOfferProductIDs] action in IconButton widget.
  List<int>? dFOids2;
  // Stores action output result for [Custom Action - getNewArrivalProductIDs] action in IconButton widget.
  List<int>? dNAids3;

  @override
  void initState(BuildContext context) {
    passwordFieldLVisibility = false;
    passwordFieldTVisibility = false;
  }

  @override
  void dispose() {
    emailFieldLFocusNode?.dispose();
    emailFieldLTextController?.dispose();

    passwordFieldLFocusNode?.dispose();
    passwordFieldLTextController?.dispose();

    emailFieldTFocusNode?.dispose();
    emailFieldTTextController?.dispose();

    passwordFieldTFocusNode?.dispose();
    passwordFieldTTextController?.dispose();
  }
}
