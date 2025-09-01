import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'editbanner_widget.dart' show EditbannerWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditbannerModel extends FlutterFlowModel<EditbannerWidget> {
  ///  Local state fields for this page.
  /// imagelink
  String? link;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - fetchPhoneBannerByEmail] action in editbanner widget.
  String? imageurl;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
