import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'plans_widget.dart' show PlansWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlansModel extends FlutterFlowModel<PlansWidget> {
  ///  Local state fields for this page.

  int? heightVariableTab = 750;

  int? heightVariableDesktop = 800;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - createTransactionForPlan] action in Button widget.
  String? planidCopy;
  // Stores action output result for [Custom Action - createTransactionForPlan] action in Button widget.
  String? planidCopymobile;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
