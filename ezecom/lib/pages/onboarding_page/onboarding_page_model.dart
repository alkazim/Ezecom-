import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'onboarding_page_widget.dart' show OnboardingPageWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OnboardingPageModel extends FlutterFlowModel<OnboardingPageWidget> {
  ///  Local state fields for this page.

  bool visiblity = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getTopDealProductIDs] action in Button widget.
  List<int>? tDids;
  // Stores action output result for [Custom Action - getFeaturedOfferProductIDs] action in Button widget.
  List<int>? fOids;
  // Stores action output result for [Custom Action - getNewArrivalProductIDs] action in Button widget.
  List<int>? nAids;
  // Stores action output result for [Custom Action - getTopDealProductIDs] action in Button widget.
  List<int>? dTDids;
  // Stores action output result for [Custom Action - getFeaturedOfferProductIDs] action in Button widget.
  List<int>? dFOids;
  // Stores action output result for [Custom Action - getNewArrivalProductIDs] action in Button widget.
  List<int>? dNAids;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
