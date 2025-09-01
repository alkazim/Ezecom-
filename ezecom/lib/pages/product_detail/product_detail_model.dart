import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/addto_cartpop_u_p_widget.dart';
import '/components/already_added_to_cart_widget.dart';
import '/components/buy_now_dialouge_widget.dart';
import '/components/no_account_widget.dart';
import '/components/notificationpopup_widget.dart';
import '/components/select_quantity_widget.dart';
import '/components/successfully_added_to_cart_widget.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'product_detail_widget.dart' show ProductDetailWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class ProductDetailModel extends FlutterFlowModel<ProductDetailWidget> {
  ///  Local state fields for this page.

  bool cartvisible = false;

  /// visbility for cart button
  String? roleCheck;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - verifyProductInUserCart] action in ProductDetail widget.
  bool? isCart2;
  // Stores action output result for [Custom Action - verifyProductInUserCart] action in ProductDetail widget.
  bool? isCartmain;
  // Stores action output result for [Custom Action - getRelatedProducts] action in ProductDetail widget.
  List<int>? relatedProductID;
  // Stores action output result for [Custom Action - fetchProductImages] action in ProductDetail widget.
  List<String>? productimages;
  // Model for AlreadyAddedToCart component.
  late AlreadyAddedToCartModel alreadyAddedToCartModel1;
  // Model for SuccessfullyAddedToCart component.
  late SuccessfullyAddedToCartModel successfullyAddedToCartModel1;
  // Stores action output result for [Custom Action - isQuantityAboveMinimum] action in Button widget.
  bool? dquantityStatuss;
  // Stores action output result for [Custom Action - verifyProductInUserCart] action in Button widget.
  bool? isCartCopyd;
  // Stores action output result for [Custom Action - addToCart] action in Button widget.
  String? addedtocart;
  // Stores action output result for [Custom Action - isQuantityAboveMinimum] action in Button widget.
  bool? quantityStatuss2;
  // State field(s) for RatingBar widget.
  double? ratingBarValue;
  // State field(s) for dQuantityTextField widget.
  FocusNode? dQuantityTextFieldFocusNode;
  TextEditingController? dQuantityTextFieldTextController;
  String? Function(BuildContext, String?)?
      dQuantityTextFieldTextControllerValidator;
  // Stores action output result for [Custom Action - isQuantityAboveMinimum] action in dQuantityTextField widget.
  bool? quantityStatus;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for QuantityTextField widget.
  FocusNode? quantityTextFieldFocusNode;
  TextEditingController? quantityTextFieldTextController;
  String? Function(BuildContext, String?)?
      quantityTextFieldTextControllerValidator;
  // Stores action output result for [Custom Action - isQuantityAboveMinimum] action in QuantityTextField widget.
  bool? mquantityStatus;
  // Model for SelectQuantity component.
  late SelectQuantityModel selectQuantityModel;
  // Stores action output result for [Custom Action - isQuantityAboveMinimum] action in AddtoCartt widget.
  bool? quantitcheck;
  // Stores action output result for [Custom Action - verifyProductInUserCart] action in AddtoCartt widget.
  bool? isCartCopyd1;
  // Stores action output result for [Custom Action - addToCart] action in AddtoCartt widget.
  String? cartInsert;
  // Stores action output result for [Custom Action - isQuantityAboveMinimum] action in Button widget.
  bool? quantityStatusformobile;
  // Model for SuccessfullyAddedToCart component.
  late SuccessfullyAddedToCartModel successfullyAddedToCartModel2;
  // Model for AlreadyAddedToCart component.
  late AlreadyAddedToCartModel alreadyAddedToCartModel2;
  // State field(s) for SearchField widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;
  // Stores action output result for [Custom Action - searchProducts] action in SearchField widget.
  List<int>? productIDs;

  @override
  void initState(BuildContext context) {
    alreadyAddedToCartModel1 =
        createModel(context, () => AlreadyAddedToCartModel());
    successfullyAddedToCartModel1 =
        createModel(context, () => SuccessfullyAddedToCartModel());
    selectQuantityModel = createModel(context, () => SelectQuantityModel());
    successfullyAddedToCartModel2 =
        createModel(context, () => SuccessfullyAddedToCartModel());
    alreadyAddedToCartModel2 =
        createModel(context, () => AlreadyAddedToCartModel());
  }

  @override
  void dispose() {
    alreadyAddedToCartModel1.dispose();
    successfullyAddedToCartModel1.dispose();
    dQuantityTextFieldFocusNode?.dispose();
    dQuantityTextFieldTextController?.dispose();

    quantityTextFieldFocusNode?.dispose();
    quantityTextFieldTextController?.dispose();

    selectQuantityModel.dispose();
    successfullyAddedToCartModel2.dispose();
    alreadyAddedToCartModel2.dispose();
    searchFieldFocusNode?.dispose();
    searchFieldTextController?.dispose();
  }
}
