import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'paymentchoose2_widget.dart' show Paymentchoose2Widget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Paymentchoose2Model extends FlutterFlowModel<Paymentchoose2Widget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - updatePaypalPriceBasedOnPlan] action in Button widget.
  bool? converstionCompleted;
  // Stores action output result for [Custom Action - getAccessToken] action in Button widget.
  String? jwttoken;
  // Stores action output result for [Custom Action - initiatePhonePePayment] action in Button widget.
  bool? urlaunched;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
