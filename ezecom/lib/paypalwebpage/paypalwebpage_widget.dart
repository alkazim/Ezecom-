import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'paypalwebpage_model.dart';
export 'paypalwebpage_model.dart';

class PaypalwebpageWidget extends StatefulWidget {
  const PaypalwebpageWidget({
    super.key,
    required this.enquiryID,
  });

  final String? enquiryID;

  static String routeName = 'Paypalwebpage';
  static String routePath = '/paypalwebpage';

  @override
  State<PaypalwebpageWidget> createState() => _PaypalwebpageWidgetState();
}

class _PaypalwebpageWidgetState extends State<PaypalwebpageWidget> {
  late PaypalwebpageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaypalwebpageModel());

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
              color: Color(0xFF7C3C3C),
            ),
            child: custom_widgets.PayPalForWeb(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: MediaQuery.sizeOf(context).height * 1.0,
              enquiryId: widget!.enquiryID!,
            ),
          ),
        ),
      ),
    );
  }
}
