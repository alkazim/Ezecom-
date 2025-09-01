import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pay_pal_plan_purchase_page_web_model.dart';
export 'pay_pal_plan_purchase_page_web_model.dart';

class PayPalPlanPurchasePageWebWidget extends StatefulWidget {
  const PayPalPlanPurchasePageWebWidget({
    super.key,
    required this.transactionToken,
  });

  final String? transactionToken;

  static String routeName = 'PayPalPlanPurchasePageWeb';
  static String routePath = '/payPalPlanPurchasePageWeb';

  @override
  State<PayPalPlanPurchasePageWebWidget> createState() =>
      _PayPalPlanPurchasePageWebWidgetState();
}

class _PayPalPlanPurchasePageWebWidgetState
    extends State<PayPalPlanPurchasePageWebWidget> {
  late PayPalPlanPurchasePageWebModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PayPalPlanPurchasePageWebModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 1.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  child: custom_widgets.PayPalForWebPlanPurchase(
                    width: double.infinity,
                    height: double.infinity,
                    enquiryId: widget!.transactionToken!,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
