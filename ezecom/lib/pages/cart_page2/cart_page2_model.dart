import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/buy_now_dialouge_cart_widget.dart';
import '/components/no_account_widget.dart';
import '/components/notificationpopup_widget.dart';
import '/components/order_placed_successfully_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'cart_page2_widget.dart' show CartPage2Widget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class CartPage2Model extends FlutterFlowModel<CartPage2Widget> {
  ///  Local state fields for this page.

  bool? cartVisiblity;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getUserRole4] action in cartPage2 widget.
  String? fetchRole;
  // Stores action output result for [Custom Action - checkAccountApproval1] action in cartPage2 widget.
  String? approvalStatus;
  // Stores action output result for [Custom Action - fetchCartList] action in cartPage2 widget.
  dynamic? cartList1;
  // Stores action output result for [Custom Action - sumPrices] action in cartPage2 widget.
  double? sumprices1;
  // Stores action output result for [Custom Action - fetchCartList] action in cartPage2 widget.
  dynamic? cartList;
  // Stores action output result for [Custom Action - calculateTotalCartPrice] action in cartPage2 widget.
  double? sumOfCart;
  // Stores action output result for [Custom Action - getCartProductCount] action in cartPage2 widget.
  int? noOfProductsinCart;
  // Stores action output result for [Custom Action - calculateContainerHeight] action in cartPage2 widget.
  int? containerHeight;
  // Model for OrderPlacedSuccessfully component.
  late OrderPlacedSuccessfullyModel orderPlacedSuccessfullyModel;
  Stream<List<PublicProductsViewRow>>? rowSupabaseStream;
  // State field(s) for SearchField widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;
  // Stores action output result for [Custom Action - searchProducts] action in SearchField widget.
  List<int>? productIDs;

  @override
  void initState(BuildContext context) {
    orderPlacedSuccessfullyModel =
        createModel(context, () => OrderPlacedSuccessfullyModel());
  }

  @override
  void dispose() {
    orderPlacedSuccessfullyModel.dispose();
    searchFieldFocusNode?.dispose();
    searchFieldTextController?.dispose();
  }
}
