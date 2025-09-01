import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pay_pal_plan_purchase_page_mobile_model.dart';
export 'pay_pal_plan_purchase_page_mobile_model.dart';

class PayPalPlanPurchasePageMobileWidget extends StatefulWidget {
  const PayPalPlanPurchasePageMobileWidget({
    super.key,
    required this.transactionToken,
  });

  final String? transactionToken;

  static String routeName = 'PayPalPlanPurchasePageMobile';
  static String routePath = '/payPalPlanPurchasePageMobile';

  @override
  State<PayPalPlanPurchasePageMobileWidget> createState() =>
      _PayPalPlanPurchasePageMobileWidgetState();
}

class _PayPalPlanPurchasePageMobileWidgetState
    extends State<PayPalPlanPurchasePageMobileWidget> {
  late PayPalPlanPurchasePageMobileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PayPalPlanPurchasePageMobileModel());

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
          child: custom_widgets.PayPalForMobilePlanPurchase(
            width: double.infinity,
            height: double.infinity,
            transactionToken: widget!.transactionToken!,
          ),
        ),
      ),
    );
  }
}
