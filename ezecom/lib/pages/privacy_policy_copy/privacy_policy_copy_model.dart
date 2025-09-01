import '/auth/base_auth_user_provider.dart';
import '/components/privacy_policy_component_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'privacy_policy_copy_widget.dart' show PrivacyPolicyCopyWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyCopyModel extends FlutterFlowModel<PrivacyPolicyCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for PrivacyPolicyComponent component.
  late PrivacyPolicyComponentModel privacyPolicyComponentModel;

  @override
  void initState(BuildContext context) {
    privacyPolicyComponentModel =
        createModel(context, () => PrivacyPolicyComponentModel());
  }

  @override
  void dispose() {
    privacyPolicyComponentModel.dispose();
  }
}
