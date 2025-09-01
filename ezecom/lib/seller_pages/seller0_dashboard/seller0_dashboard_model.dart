import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'seller0_dashboard_widget.dart' show Seller0DashboardWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Seller0DashboardModel extends FlutterFlowModel<Seller0DashboardWidget> {
  ///  Local state fields for this page.

  bool pvisible = false;

  bool bvisible = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkBannerEmail] action in Seller0Dashboard widget.
  String? bannerNo;
  // Stores action output result for [Custom Action - fetchPhoneBannerByEmail] action in Button widget.
  String? imageurl;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
