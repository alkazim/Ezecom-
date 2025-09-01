import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'buy_now_dialouge_cart_widget.dart' show BuyNowDialougeCartWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BuyNowDialougeCartModel
    extends FlutterFlowModel<BuyNowDialougeCartWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - placeOrderAction] action in Container widget.
  String? placeOrderAction;
  // Stores action output result for [Custom Action - paymentFactoryThroughCart] action in Container widget.
  String? factCartEnquiryID;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
