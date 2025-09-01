import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'plan_confirm_widget.dart' show PlanConfirmWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlanConfirmModel extends FlutterFlowModel<PlanConfirmWidget> {
  ///  Local state fields for this page.

  String approvalStatus = 'null';

  bool documentVerification = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getUserAccountApproval] action in PlanConfirm widget.
  String? accountApproval;
  // Stores action output result for [Custom Action - getUserPaymentStatus] action in PlanConfirm widget.
  String? paymentStatus;
  // Stores action output result for [Custom Action - getUserRole4] action in PlanConfirm widget.
  String? role;
  // Stores action output result for [Custom Action - checkUserApprovalAndDocuments] action in PlanConfirm widget.
  bool? docStatusBuyer;
  // Stores action output result for [Custom Action - checkUserApprovalAndDocuments] action in PlanConfirm widget.
  bool? docStatusSeller;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
