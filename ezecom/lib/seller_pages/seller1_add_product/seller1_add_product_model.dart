import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/add_product_failed_widget.dart';
import '/components/product_added_successfully_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'seller1_add_product_widget.dart' show Seller1AddProductWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Seller1AddProductModel extends FlutterFlowModel<Seller1AddProductWidget> {
  ///  Local state fields for this page.

  String? backendactionvalue;

  bool otherCategory = false;

  bool otherSubCategory = false;

  String mCategory = 'null';

  String mSubcategory = 'null';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkUserProductLimit] action in Seller1AddProduct widget.
  String? productLimit;
  // Stores action output result for [Custom Action - fetchCategoryNames1] action in Seller1AddProduct widget.
  List<String>? mcategoryyNames;
  // Stores action output result for [Custom Action - getSellerCompanyName] action in Seller1AddProduct widget.
  String? sellerCompanyName;
  // State field(s) for MproductNameField widget.
  FocusNode? mproductNameFieldFocusNode;
  TextEditingController? mproductNameFieldTextController;
  String? Function(BuildContext, String?)?
      mproductNameFieldTextControllerValidator;
  // State field(s) for MQuantityField widget.
  FocusNode? mQuantityFieldFocusNode;
  TextEditingController? mQuantityFieldTextController;
  String? Function(BuildContext, String?)?
      mQuantityFieldTextControllerValidator;
  // State field(s) for MCategoryDropDown widget.
  String? mCategoryDropDownValue;
  FormFieldController<String>? mCategoryDropDownValueController;
  // Stores action output result for [Custom Action - getCategoryIdByName] action in MCategoryDropDown widget.
  String? mCategoryID;
  // Stores action output result for [Custom Action - getSubcategoriesByCategoryId] action in MCategoryDropDown widget.
  List<String>? mSubCategoryList;
  // State field(s) for MOtherCategory widget.
  FocusNode? mOtherCategoryFocusNode;
  TextEditingController? mOtherCategoryTextController;
  String? Function(BuildContext, String?)?
      mOtherCategoryTextControllerValidator;
  // State field(s) for MSubCategoryDropDown widget.
  String? mSubCategoryDropDownValue;
  FormFieldController<String>? mSubCategoryDropDownValueController;
  // Stores action output result for [Custom Action - getSubcategoryID] action in MSubCategoryDropDown widget.
  String? mSubCategoryIDothers;
  // Stores action output result for [Custom Action - getSubcategoryID] action in MSubCategoryDropDown widget.
  String? mSubCategoryID;
  // State field(s) for MOtherSubCategory widget.
  FocusNode? mOtherSubCategoryFocusNode;
  TextEditingController? mOtherSubCategoryTextController;
  String? Function(BuildContext, String?)?
      mOtherSubCategoryTextControllerValidator;
  // State field(s) for MProductDescriptionField widget.
  FocusNode? mProductDescriptionFieldFocusNode;
  TextEditingController? mProductDescriptionFieldTextController;
  String? Function(BuildContext, String?)?
      mProductDescriptionFieldTextControllerValidator;
  // State field(s) for MproductModelField widget.
  FocusNode? mproductModelFieldFocusNode;
  TextEditingController? mproductModelFieldTextController;
  String? Function(BuildContext, String?)?
      mproductModelFieldTextControllerValidator;
  // State field(s) for MPriceField widget.
  FocusNode? mPriceFieldFocusNode;
  TextEditingController? mPriceFieldTextController;
  String? Function(BuildContext, String?)? mPriceFieldTextControllerValidator;
  // State field(s) for MDiscountField widget.
  FocusNode? mDiscountFieldFocusNode;
  TextEditingController? mDiscountFieldTextController;
  String? Function(BuildContext, String?)?
      mDiscountFieldTextControllerValidator;
  // Stores action output result for [Custom Action - calculateDiscountedPrice] action in Button widget.
  double? discountedPrice;
  // Stores action output result for [Custom Action - uploadSelectedImageToSupabase] action in Button widget.
  List<String>? uploadstatus;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  ProductsTableRow? productresult;
  // State field(s) for dDescriptionField widget.
  FocusNode? dDescriptionFieldFocusNode;
  TextEditingController? dDescriptionFieldTextController;
  String? Function(BuildContext, String?)?
      dDescriptionFieldTextControllerValidator;
  // State field(s) for dProductNameField widget.
  FocusNode? dProductNameFieldFocusNode;
  TextEditingController? dProductNameFieldTextController;
  String? Function(BuildContext, String?)?
      dProductNameFieldTextControllerValidator;
  // State field(s) for dQuantityField widget.
  FocusNode? dQuantityFieldFocusNode;
  TextEditingController? dQuantityFieldTextController;
  String? Function(BuildContext, String?)?
      dQuantityFieldTextControllerValidator;
  // State field(s) for dCategoryDropDown widget.
  String? dCategoryDropDownValue;
  FormFieldController<String>? dCategoryDropDownValueController;
  // Stores action output result for [Custom Action - getCategoryIdByName] action in dCategoryDropDown widget.
  String? categoryID;
  // Stores action output result for [Custom Action - getSubcategoriesByCategoryId] action in dCategoryDropDown widget.
  List<String>? subCategoryList;
  // State field(s) for dOtherCategory widget.
  FocusNode? dOtherCategoryFocusNode;
  TextEditingController? dOtherCategoryTextController;
  String? Function(BuildContext, String?)?
      dOtherCategoryTextControllerValidator;
  // State field(s) for dSubCategoryDropDown widget.
  String? dSubCategoryDropDownValue;
  FormFieldController<String>? dSubCategoryDropDownValueController;
  // Stores action output result for [Custom Action - getSubcategoryID] action in dSubCategoryDropDown widget.
  String? subCategoryID;
  // State field(s) for dOtherSubCategory widget.
  FocusNode? dOtherSubCategoryFocusNode;
  TextEditingController? dOtherSubCategoryTextController;
  String? Function(BuildContext, String?)?
      dOtherSubCategoryTextControllerValidator;
  // State field(s) for dPriceField widget.
  FocusNode? dPriceFieldFocusNode;
  TextEditingController? dPriceFieldTextController;
  String? Function(BuildContext, String?)? dPriceFieldTextControllerValidator;
  // State field(s) for dDiscountField widget.
  FocusNode? dDiscountFieldFocusNode;
  TextEditingController? dDiscountFieldTextController;
  String? Function(BuildContext, String?)?
      dDiscountFieldTextControllerValidator;
  // State field(s) for dModelNoField widget.
  FocusNode? dModelNoFieldFocusNode;
  TextEditingController? dModelNoFieldTextController;
  String? Function(BuildContext, String?)? dModelNoFieldTextControllerValidator;
  // Model for ProductAddedSuccessfully component.
  late ProductAddedSuccessfullyModel productAddedSuccessfullyModel1;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel1;
  // Stores action output result for [Custom Action - calculateDiscountedPrice] action in Button widget.
  double? dDiscountedPrice;
  // Stores action output result for [Custom Action - uploadSelectedImageToSupabase] action in Button widget.
  List<String>? duploadstatus;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  ProductsTableRow? dproductresult;
  // Model for ProductAddedSuccessfully component.
  late ProductAddedSuccessfullyModel productAddedSuccessfullyModel2;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel2;
  // Model for ProductAddedSuccessfully component.
  late ProductAddedSuccessfullyModel productAddedSuccessfullyModel3;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel3;

  @override
  void initState(BuildContext context) {
    productAddedSuccessfullyModel1 =
        createModel(context, () => ProductAddedSuccessfullyModel());
    addProductFailedModel1 =
        createModel(context, () => AddProductFailedModel());
    productAddedSuccessfullyModel2 =
        createModel(context, () => ProductAddedSuccessfullyModel());
    addProductFailedModel2 =
        createModel(context, () => AddProductFailedModel());
    productAddedSuccessfullyModel3 =
        createModel(context, () => ProductAddedSuccessfullyModel());
    addProductFailedModel3 =
        createModel(context, () => AddProductFailedModel());
  }

  @override
  void dispose() {
    mproductNameFieldFocusNode?.dispose();
    mproductNameFieldTextController?.dispose();

    mQuantityFieldFocusNode?.dispose();
    mQuantityFieldTextController?.dispose();

    mOtherCategoryFocusNode?.dispose();
    mOtherCategoryTextController?.dispose();

    mOtherSubCategoryFocusNode?.dispose();
    mOtherSubCategoryTextController?.dispose();

    mProductDescriptionFieldFocusNode?.dispose();
    mProductDescriptionFieldTextController?.dispose();

    mproductModelFieldFocusNode?.dispose();
    mproductModelFieldTextController?.dispose();

    mPriceFieldFocusNode?.dispose();
    mPriceFieldTextController?.dispose();

    mDiscountFieldFocusNode?.dispose();
    mDiscountFieldTextController?.dispose();

    dDescriptionFieldFocusNode?.dispose();
    dDescriptionFieldTextController?.dispose();

    dProductNameFieldFocusNode?.dispose();
    dProductNameFieldTextController?.dispose();

    dQuantityFieldFocusNode?.dispose();
    dQuantityFieldTextController?.dispose();

    dOtherCategoryFocusNode?.dispose();
    dOtherCategoryTextController?.dispose();

    dOtherSubCategoryFocusNode?.dispose();
    dOtherSubCategoryTextController?.dispose();

    dPriceFieldFocusNode?.dispose();
    dPriceFieldTextController?.dispose();

    dDiscountFieldFocusNode?.dispose();
    dDiscountFieldTextController?.dispose();

    dModelNoFieldFocusNode?.dispose();
    dModelNoFieldTextController?.dispose();

    productAddedSuccessfullyModel1.dispose();
    addProductFailedModel1.dispose();
    productAddedSuccessfullyModel2.dispose();
    addProductFailedModel2.dispose();
    productAddedSuccessfullyModel3.dispose();
    addProductFailedModel3.dispose();
  }
}
