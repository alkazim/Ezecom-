import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'addto_cart_button_model.dart';
export 'addto_cart_button_model.dart';

class AddtoCartButtonWidget extends StatefulWidget {
  const AddtoCartButtonWidget({
    super.key,
    required this.isCartmain,
    required this.quantity,
    required this.minimumQuantity,
    required this.productId,
  });

  final bool? isCartmain;
  final String? quantity;
  final double? minimumQuantity;
  final int? productId;

  @override
  State<AddtoCartButtonWidget> createState() => _AddtoCartButtonWidgetState();
}

class _AddtoCartButtonWidgetState extends State<AddtoCartButtonWidget> {
  late AddtoCartButtonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddtoCartButtonModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
