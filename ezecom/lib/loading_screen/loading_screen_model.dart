import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'loading_screen_widget.dart' show LoadingScreenWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoadingScreenModel extends FlutterFlowModel<LoadingScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getUserRole4] action in LoadingScreen widget.
  String? fetchRole;
  // Stores action output result for [Custom Action - checkAccountApproval1] action in LoadingScreen widget.
  String? approvalStatus1;
  // Stores action output result for [Custom Action - getExpiryCheckValue] action in LoadingScreen widget.
  bool? expiryStatus;
  // Stores action output result for [Custom Action - getPaymentStatusFromSellerUser] action in LoadingScreen widget.
  String? paymentStatsuSeller;
  // Stores action output result for [Custom Action - checkAccountApproval1] action in LoadingScreen widget.
  String? approvalStatus1copy;
  // Stores action output result for [Custom Action - getTopDealProductIDs] action in LoadingScreen widget.
  List<int>? tDids;
  // Stores action output result for [Custom Action - getFeaturedOfferProductIDs] action in LoadingScreen widget.
  List<int>? fOids;
  // Stores action output result for [Custom Action - getNewArrivalProductIDs] action in LoadingScreen widget.
  List<int>? nAids;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
