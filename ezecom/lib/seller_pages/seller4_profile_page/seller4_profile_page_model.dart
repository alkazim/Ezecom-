import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/confirm_dialouge_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'seller4_profile_page_widget.dart' show Seller4ProfilePageWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class Seller4ProfilePageModel
    extends FlutterFlowModel<Seller4ProfilePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getTopDealProductIDs] action in Container widget.
  List<int>? tDids;
  // Stores action output result for [Custom Action - getFeaturedOfferProductIDs] action in Container widget.
  List<int>? fOids;
  // Stores action output result for [Custom Action - getNewArrivalProductIDs] action in Container widget.
  List<int>? nAids;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
