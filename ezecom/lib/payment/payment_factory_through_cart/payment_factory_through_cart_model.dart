import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'payment_factory_through_cart_widget.dart'
    show PaymentFactoryThroughCartWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentFactoryThroughCartModel
    extends FlutterFlowModel<PaymentFactoryThroughCartWidget> {
  ///  Local state fields for this page.

  bool itemVisible = false;

  /// total price visiblility
  bool tpVisibility = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getCartProductCount] action in PaymentFactoryThroughCart widget.
  int? cartCount;
  // Stores action output result for [Custom Action - calculateTotalPriceByEnquiryId] action in PaymentFactoryThroughCart widget.
  double? totalprice;
  // Stores action output result for [Custom Action - multiplyPlanAmount] action in PaymentFactoryThroughCart widget.
  double? amt;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
