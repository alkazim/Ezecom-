import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'paypalmobilepage_model.dart';
export 'paypalmobilepage_model.dart';

class PaypalmobilepageWidget extends StatefulWidget {
  const PaypalmobilepageWidget({
    super.key,
    required this.enquiryID,
  });

  final String? enquiryID;

  static String routeName = 'Paypalmobilepage';
  static String routePath = '/paypalmobilepage';

  @override
  State<PaypalmobilepageWidget> createState() => _PaypalmobilepageWidgetState();
}

class _PaypalmobilepageWidgetState extends State<PaypalmobilepageWidget> {
  late PaypalmobilepageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaypalmobilepageModel());

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
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: custom_widgets.PayPalForMobile(
                width: double.infinity,
                height: double.infinity,
                enquiryId: widget!.enquiryID!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
