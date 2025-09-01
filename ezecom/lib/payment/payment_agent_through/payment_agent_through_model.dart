import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/error_occured_widget.dart';
import '/components/order_placed_successfully_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'payment_agent_through_widget.dart' show PaymentAgentThroughWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentAgentThroughModel
    extends FlutterFlowModel<PaymentAgentThroughWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for OrderPlacedSuccessfully component.
  late OrderPlacedSuccessfullyModel orderPlacedSuccessfullyModel;
  // Model for ErrorOccured component.
  late ErrorOccuredModel errorOccuredModel;

  @override
  void initState(BuildContext context) {
    orderPlacedSuccessfullyModel =
        createModel(context, () => OrderPlacedSuccessfullyModel());
    errorOccuredModel = createModel(context, () => ErrorOccuredModel());
  }

  @override
  void dispose() {
    orderPlacedSuccessfullyModel.dispose();
    errorOccuredModel.dispose();
  }
}
