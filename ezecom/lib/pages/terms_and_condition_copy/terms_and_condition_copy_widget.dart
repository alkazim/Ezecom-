import '/components/terms_and_condition_component_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'terms_and_condition_copy_model.dart';
export 'terms_and_condition_copy_model.dart';

class TermsAndConditionCopyWidget extends StatefulWidget {
  const TermsAndConditionCopyWidget({super.key});

  static String routeName = 'TermsAndConditionCopy';
  static String routePath = '/termsAndConditionCopy';

  @override
  State<TermsAndConditionCopyWidget> createState() =>
      _TermsAndConditionCopyWidgetState();
}

class _TermsAndConditionCopyWidgetState
    extends State<TermsAndConditionCopyWidget> {
  late TermsAndConditionCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TermsAndConditionCopyModel());

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
          leading: Padding(
            padding: EdgeInsets.all(6.0),
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: FlutterFlowIconButton(
                borderRadius: 8.0,
                buttonSize: 35.0,
                icon: Icon(
                  Icons.arrow_back,
                  color: FlutterFlowTheme.of(context).info,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pushNamed(
                    SettingWidget.routeName,
                    queryParameters: {
                      'emailID': serializeParam(
                        '',
                        ParamType.String,
                      ),
                      'companyName': serializeParam(
                        '',
                        ParamType.String,
                      ),
                      'role': serializeParam(
                        '',
                        ParamType.String,
                      ),
                    }.withoutNulls,
                  );
                },
              ),
            ),
          ),
          title: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 60.0, 0.0),
              child: Text(
                'Terms & Conditions',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: Colors.black,
                      fontSize: 25.0,
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: wrapWithModel(
            model: _model.termsAndConditionComponentModel,
            updateCallback: () => safeSetState(() {}),
            child: TermsAndConditionComponentWidget(),
          ),
        ),
      ),
    );
  }
}
