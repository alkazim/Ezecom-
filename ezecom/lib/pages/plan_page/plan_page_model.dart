import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/confirm_dialouge_widget.dart';
import '/components/plan_purchase_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'plan_page_widget.dart' show PlanPageWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class PlanPageModel extends FlutterFlowModel<PlanPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getUserPlanType] action in PlanPage widget.
  String? type;
  Stream<List<PlanTableRow>>? containerSupabaseStream1;
  Stream<List<PlanTableRow>>? containerSupabaseStream2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
