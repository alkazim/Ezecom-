import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'addto_cart_model.dart';
export 'addto_cart_model.dart';

class AddtoCartWidget extends StatefulWidget {
  const AddtoCartWidget({
    super.key,
    required this.parameter1,
    required this.parameter2,
    required this.parameter3,
    this.parameter4,
    required this.parameter5,
    this.parameter6,
  });

  final bool? parameter1;
  final bool? parameter2;
  final int? parameter3;
  final String? parameter4;
  final bool? parameter5;
  final int? parameter6;

  @override
  State<AddtoCartWidget> createState() => _AddtoCartWidgetState();
}

class _AddtoCartWidgetState extends State<AddtoCartWidget> {
  late AddtoCartModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddtoCartModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget!.parameter1 == false,
      child: FFButtonWidget(
        onPressed: () async {
          _model.quantityStatuss = await actions.isQuantityAboveMinimum(
            widget!.parameter4!,
            widget!.parameter6!.toDouble(),
          );
          if (_model.quantityStatuss == true) {
            _model.isCart = await actions.verifyProductInUserCart(
              currentUserEmail,
              widget!.parameter3!,
            );
            if (_model.isCart == true) {
              FFAppState().snackbar6 = true;
              safeSetState(() {});
              await Future.delayed(
                Duration(
                  milliseconds: 3000,
                ),
              );
              FFAppState().snackbar6 = false;
              safeSetState(() {});
            } else {
              await actions.addToCart(
                currentUserEmail,
                widget!.parameter3!.toString(),
                widget!.parameter4!,
              );
              FFAppState().snackbar7 = true;
              safeSetState(() {});
              await Future.delayed(
                Duration(
                  milliseconds: 3000,
                ),
              );
              FFAppState().snackbar7 = false;
              safeSetState(() {});
            }
          } else {
            FFAppState().snackbar5 = true;
            safeSetState(() {});
            await Future.delayed(
              Duration(
                milliseconds: 3000,
              ),
            );
            FFAppState().snackbar5 = false;
            safeSetState(() {});
          }

          safeSetState(() {});
        },
        text: 'Add to Cart',
        options: FFButtonOptions(
          width: double.infinity,
          height: 40.0,
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: Color(0xFF202020),
          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                font: GoogleFonts.poppins(
                  fontWeight: FontWeight.w300,
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                ),
                color: Color(0xFFF3F3F3),
                letterSpacing: 0.0,
                fontWeight: FontWeight.w300,
                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
              ),
          elevation: 0.0,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
