import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'addto_cartpop_u_p_widget.dart' show AddtoCartpopUPWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddtoCartpopUPModel extends FlutterFlowModel<AddtoCartpopUPWidget> {
  ///  Local state fields for this component.

  bool visible = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - getCartProductCount] action in AddtoCartpopUP widget.
  int? cartCount;
  // Stores action output result for [Custom Action - calculateTotalCartPrice] action in AddtoCartpopUP widget.
  double? sum;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
