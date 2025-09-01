import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'redirecthandler_plan_model.dart';
export 'redirecthandler_plan_model.dart';

class RedirecthandlerPlanWidget extends StatefulWidget {
  const RedirecthandlerPlanWidget({
    super.key,
    required this.transactionToken,
    required this.status,
    required this.token,
  });

  final String? transactionToken;
  final String? status;
  final String? token;

  static String routeName = 'RedirecthandlerPlan';
  static String routePath = '/paypal-redirect-handler-plan-web';

  @override
  State<RedirecthandlerPlanWidget> createState() =>
      _RedirecthandlerPlanWidgetState();
}

class _RedirecthandlerPlanWidgetState extends State<RedirecthandlerPlanWidget> {
  late RedirecthandlerPlanModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RedirecthandlerPlanModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if ((widget!.status == 'success') &&
          (widget!.transactionToken != null &&
              widget!.transactionToken != '') &&
          (widget!.token != null && widget!.token != '')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'hurrray condition done',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
        _model.payment = await actions.callCapturePaypalOrderWebPlanPurchase(
          context,
          widget!.token!,
          widget!.transactionToken!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _model.payment!.toString(),
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
        if (_model.payment!) {
          context.pushNamed(PaymentSuccessfulWidget.routeName);
        } else {
          context.pushNamed(PaymentFailedWidget.routeName);
        }
      } else {
        context.pushNamed(PaymentFailedWidget.routeName);
      }
    });

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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: MediaQuery.sizeOf(context).height * 1.0,
                            decoration: BoxDecoration(
                              color: Color(0xFFC3BFE5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
