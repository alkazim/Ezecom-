import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'testmyorders_model.dart';
export 'testmyorders_model.dart';

class TestmyordersWidget extends StatefulWidget {
  const TestmyordersWidget({
    super.key,
    required this.index,
  });

  final int? index;

  static String routeName = 'TESTMYORDERS';
  static String routePath = '/testmyorders';

  @override
  State<TestmyordersWidget> createState() => _TestmyordersWidgetState();
}

class _TestmyordersWidgetState extends State<TestmyordersWidget>
    with TickerProviderStateMixin {
  late TestmyordersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TestmyordersModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: min(
          valueOrDefault<int>(
            widget!.index,
            0,
          ),
          1),
    )..addListener(() => safeSetState(() {}));

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
        appBar: AppBar(
          backgroundColor: Color(0xFF3BBCF7),
          automaticallyImplyLeading: false,
          title: Container(
            width: 311.72,
            height: 100.0,
            constraints: BoxConstraints(
              minWidth: double.infinity,
            ),
            decoration: BoxDecoration(
              color: Color(0xFF3BBCF7),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(-0.06, 0.11),
                  child: Text(
                    'My Orders',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          fontSize: 22.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1.0, 0.03),
                  child: FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.arrow_back,
                      color: FlutterFlowTheme.of(context).info,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      context.pushNamed(ProfileBuyerWidget.routeName);
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Align(
                alignment: Alignment(0.0, 0),
                child: FlutterFlowButtonTabBar(
                  useToggleButtonStyle: true,
                  labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                  unselectedLabelStyle: FlutterFlowTheme.of(context)
                      .titleMedium
                      .override(
                        font: GoogleFonts.interTight(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                  labelColor: Color(0xFF3BBCF7),
                  unselectedLabelColor: Color(0xFF62C8F7),
                  backgroundColor: Color(0xFFD2E2E7),
                  unselectedBackgroundColor:
                      FlutterFlowTheme.of(context).alternate,
                  borderColor: Color(0xFF3BBCF7),
                  unselectedBorderColor: FlutterFlowTheme.of(context).alternate,
                  borderWidth: 2.0,
                  borderRadius: 8.0,
                  elevation: 0.0,
                  buttonMargin:
                      EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                  padding: EdgeInsets.all(4.0),
                  tabs: [
                    Tab(
                      text: 'Agent Through',
                    ),
                    Tab(
                      text: 'Factory Through',
                    ),
                  ],
                  controller: _model.tabBarController,
                  onTap: (i) async {
                    [() async {}, () async {}][i]();
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _model.tabBarController,
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: custom_widgets.OrderTrackingDisplay(
                        width: double.infinity,
                        height: double.infinity,
                        buyerEmail: currentUserEmail,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: custom_widgets.FactoryOrderTrackingDisplay(
                        width: double.infinity,
                        height: double.infinity,
                        buyerEmail: currentUserEmail,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
