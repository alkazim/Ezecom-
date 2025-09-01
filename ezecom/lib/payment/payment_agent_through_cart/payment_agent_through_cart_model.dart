import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'payment_agent_through_cart_widget.dart'
    show PaymentAgentThroughCartWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentAgentThroughCartModel
    extends FlutterFlowModel<PaymentAgentThroughCartWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getCartProductCount] action in PaymentAgentThroughCart widget.
  int? cartCount;
  // Stores action output result for [Custom Action - getTotalPriceByEnquiryId] action in PaymentAgentThroughCart widget.
  String? cartPriceAmount;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
