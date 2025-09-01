import '/components/no_account_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'test3_widget.dart' show Test3Widget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class Test3Model extends FlutterFlowModel<Test3Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for SearchFieldweb widget.
  FocusNode? searchFieldwebFocusNode;
  TextEditingController? searchFieldwebTextController;
  String? Function(BuildContext, String?)?
      searchFieldwebTextControllerValidator;
  // Stores action output result for [Custom Action - searchProducts] action in SearchFieldweb widget.
  List<int>? productIDsweb;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFieldwebFocusNode?.dispose();
    searchFieldwebTextController?.dispose();
  }
}
