import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'loading_screen_model.dart';
export 'loading_screen_model.dart';

class LoadingScreenWidget extends StatefulWidget {
  const LoadingScreenWidget({super.key});

  static String routeName = 'LoadingScreen';
  static String routePath = '/loadingScreen';

  @override
  State<LoadingScreenWidget> createState() => _LoadingScreenWidgetState();
}

class _LoadingScreenWidgetState extends State<LoadingScreenWidget>
    with TickerProviderStateMixin {
  late LoadingScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadingScreenModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.fetchRole = await actions.getUserRole4();
      FFAppState().Role = _model.fetchRole!;
      FFAppState().initialState = true;
      safeSetState(() {});
      if (FFAppState().Role == 'seller') {
        _model.approvalStatus1 = await actions.checkAccountApproval1(
          currentUserEmail,
        );
        if ((_model.approvalStatus1 == 'rejected') ||
            (_model.approvalStatus1 == 'suspended')) {
          context.pushNamed(PlanConfirmWidget.routeName);
        } else {
          if (_model.approvalStatus1 == 'approved') {
            _model.expiryStatus = await actions.getExpiryCheckValue(
              currentUserUid,
            );
            if (_model.expiryStatus!) {
              context.pushNamed(
                PlanConfirmWidget.routeName,
                queryParameters: {
                  'sellerExpiry': serializeParam(
                    true,
                    ParamType.bool,
                  ),
                }.withoutNulls,
              );
            } else {
              if (MediaQuery.sizeOf(context).width < 1024.0) {
                context.pushNamed(SellerPageWidget.routeName);
              } else {
                context.goNamed(Seller0DashboardWidget.routeName);
              }
            }
          } else {
            _model.paymentStatsuSeller =
                await actions.getPaymentStatusFromSellerUser(
              currentUserEmail,
            );
            if (_model.paymentStatsuSeller == 'completed') {
              context.goNamed(PlanConfirmWidget.routeName);
            } else {
              context.goNamed(
                PlansWidget.routeName,
                queryParameters: {
                  'currentUserMailID': serializeParam(
                    '',
                    ParamType.String,
                  ),
                  'companyName': serializeParam(
                    '',
                    ParamType.String,
                  ),
                }.withoutNulls,
              );
            }
          }
        }
      } else {
        FFAppState().initialState = true;
        safeSetState(() {});
        if (FFAppState().Role == 'noUser') {
          context.pushNamed(HomePageWidget.routeName);
        } else {
          _model.approvalStatus1copy = await actions.checkAccountApproval1(
            currentUserEmail,
          );
          if ((_model.approvalStatus1copy == 'rejected') ||
              (_model.approvalStatus1copy == 'suspended')) {
            context.pushNamed(PlanConfirmWidget.routeName);
          } else {
            if (_model.approvalStatus1copy == 'approved') {
              _model.tDids = await actions.getTopDealProductIDs();
              _model.fOids = await actions.getFeaturedOfferProductIDs();
              _model.nAids = await actions.getNewArrivalProductIDs();
              FFAppState().TDpids = _model.tDids!.toList().cast<int>();
              FFAppState().FOpids = _model.fOids!.toList().cast<int>();
              FFAppState().NApids = _model.nAids!.toList().cast<int>();
              safeSetState(() {});

              context.pushNamed(HomePageWidget.routeName);
            } else {
              context.goNamed(PlanConfirmWidget.routeName);
            }
          }
        }
      }
    });

    animationsMap.addAll({
      'imageOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          RotateEffect(
            curve: Curves.linear,
            delay: 0.0.ms,
            duration: 1200.0.ms,
            begin: 1.0,
            end: 0.0,
          ),
        ],
      ),
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
    context.watch<FFAppState>();

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
          child: Visibility(
            visible: !((FFAppState().Role == 'buyer') ||
                (FFAppState().Role == 'noUser')),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Container(
                  width: 237.6,
                  height: 218.7,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/Variant5.png',
                            width: 177.0,
                            height: 177.0,
                            fit: BoxFit.contain,
                            alignment: Alignment(0.0, 0.0),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation']!),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 124.0,
                          height: 124.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: Image.asset(
                                'assets/images/Group_2147.png',
                              ).image,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
