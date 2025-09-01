import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'addto_cart_widget.dart' show AddtoCartWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddtoCartModel extends FlutterFlowModel<AddtoCartWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - isQuantityAboveMinimum] action in AddtoCart widget.
  bool? quantityStatuss;
  // Stores action output result for [Custom Action - verifyProductInUserCart] action in AddtoCart widget.
  bool? isCart;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
