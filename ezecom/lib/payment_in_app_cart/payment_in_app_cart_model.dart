import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/order_placed_successfully_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'payment_in_app_cart_widget.dart' show PaymentInAppCartWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentInAppCartModel extends FlutterFlowModel<PaymentInAppCartWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for OrderPlacedSuccessfully component.
  late OrderPlacedSuccessfullyModel orderPlacedSuccessfullyModel;

  @override
  void initState(BuildContext context) {
    orderPlacedSuccessfullyModel =
        createModel(context, () => OrderPlacedSuccessfullyModel());
  }

  @override
  void dispose() {
    orderPlacedSuccessfullyModel.dispose();
  }
}
