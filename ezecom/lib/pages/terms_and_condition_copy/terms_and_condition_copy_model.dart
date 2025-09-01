import '/components/terms_and_condition_component_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'terms_and_condition_copy_widget.dart' show TermsAndConditionCopyWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TermsAndConditionCopyModel
    extends FlutterFlowModel<TermsAndConditionCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for termsAndConditionComponent component.
  late TermsAndConditionComponentModel termsAndConditionComponentModel;

  @override
  void initState(BuildContext context) {
    termsAndConditionComponentModel =
        createModel(context, () => TermsAndConditionComponentModel());
  }

  @override
  void dispose() {
    termsAndConditionComponentModel.dispose();
  }
}
