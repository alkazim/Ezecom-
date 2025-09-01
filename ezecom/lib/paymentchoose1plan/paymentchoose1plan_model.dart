import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'paymentchoose1plan_widget.dart' show Paymentchoose1planWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Paymentchoose1planModel
    extends FlutterFlowModel<Paymentchoose1planWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<PaymentTransactionsPlanRow>? currentPlanID;
  // Stores action output result for [Custom Action - updateAmountPaidFromIndianPrice] action in Button widget.
  bool? inr;
  // Stores action output result for [Custom Action - getAccessToken] action in Button widget.
  String? jwttoken;
  // Stores action output result for [Custom Action - initiatePhonePePaymentPlanPurchase] action in Button widget.
  bool? urllaunched;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
