import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/add_product_failed_widget.dart';
import '/components/banner_added_successfully_widget.dart';
import '/components/confirm_dialouge_widget.dart';
import '/components/failedto_upload_image_widget.dart';
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
import 'seller_page_widget.dart' show SellerPageWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class SellerPageModel extends FlutterFlowModel<SellerPageWidget> {
  ///  Local state fields for this page.

  String sellerPage = 'dashboard';

  bool pvisuble = false;

  bool bvisible = false;

  String? backendactionvalue;

  bool otherCategory = false;

  bool otherSubCategory = false;

  String mCategory = 'null';

  String mSubcategory = 'null';

  String bannerVisibility = 'null';

  String desktoplink = 'false';

  String phonelink = 'false';

  List<String> bannerListProduct = [];
  void addToBannerListProduct(String item) => bannerListProduct.add(item);
  void removeFromBannerListProduct(String item) =>
      bannerListProduct.remove(item);
  void removeAtIndexFromBannerListProduct(int index) =>
      bannerListProduct.removeAt(index);
  void insertAtIndexInBannerListProduct(int index, String item) =>
      bannerListProduct.insert(index, item);
  void updateBannerListProductAtIndex(int index, Function(String) updateFn) =>
      bannerListProduct[index] = updateFn(bannerListProduct[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkBannerEmail] action in SellerPage widget.
  String? bannerNo;
  // Stores action output result for [Custom Action - checkUserProductLimit] action in Container widget.
  String? productLimit;
  // Stores action output result for [Custom Action - fetchCategoryNames1] action in Container widget.
  List<String>? mcategoryyNames;
  // Stores action output result for [Custom Action - getSellerCompanyName] action in Container widget.
  String? sellerCompanyName;
  // Stores action output result for [Custom Action - checkBannerApprovalStatus] action in Container widget.
  String? bannerApprovalStatus;
  // Stores action output result for [Custom Action - getProductsBySeller] action in Container widget.
  List<String>? bannerProductsList;
  // Stores action output result for [Custom Action - getSellerProductsWithBanners] action in Container widget.
  List<String>? sellerProductsWithBanners;
  // Stores action output result for [Custom Action - getApprovedProductNamesBySellerEmail] action in Container widget.
  List<String>? sellerApprovedProductList;
  // Stores action output result for [Custom Action - fetchPhoneBannerByEmail] action in Container widget.
  String? phonebanner;
  // Stores action output result for [Custom Action - fetchDesktopBannerByEmail] action in Container widget.
  String? desktopbanner;
  // Stores action output result for [Custom Action - fetchCurrentProductName] action in Container widget.
  String? productfoundname;
  // Stores action output result for [Backend Call - Query Rows] action in Container widget.
  List<ProductsTableRow>? productlist;
  // Stores action output result for [Custom Action - getProductsBySeller] action in Container widget.
  List<String>? bannerProductList;
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
  // State field(s) for MOtherCategory widget.
  FocusNode? mOtherCategoryFocusNode1;
  TextEditingController? mOtherCategoryTextController1;
  String? Function(BuildContext, String?)?
      mOtherCategoryTextController1Validator;
  // State field(s) for dSubCategoryDropDown widget.
  String? dSubCategoryDropDownValue;
  FormFieldController<String>? dSubCategoryDropDownValueController;
  // Stores action output result for [Custom Action - getSubcategoryID] action in dSubCategoryDropDown widget.
  String? subCategoryID;
  // State field(s) for MOtherSubCategory widget.
  FocusNode? mOtherSubCategoryFocusNode1;
  TextEditingController? mOtherSubCategoryTextController1;
  String? Function(BuildContext, String?)?
      mOtherSubCategoryTextController1Validator;
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
  FocusNode? mOtherCategoryFocusNode2;
  TextEditingController? mOtherCategoryTextController2;
  String? Function(BuildContext, String?)?
      mOtherCategoryTextController2Validator;
  // State field(s) for MSubCategoryDropDown widget.
  String? mSubCategoryDropDownValue;
  FormFieldController<String>? mSubCategoryDropDownValueController;
  // Stores action output result for [Custom Action - getSubcategoryID] action in MSubCategoryDropDown widget.
  String? mSubCategoryID;
  // State field(s) for MOtherSubCategory widget.
  FocusNode? mOtherSubCategoryFocusNode2;
  TextEditingController? mOtherSubCategoryTextController2;
  String? Function(BuildContext, String?)?
      mOtherSubCategoryTextController2Validator;
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
  // Model for ProductAddedSuccessfully component.
  late ProductAddedSuccessfullyModel productAddedSuccessfullyModel3;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel3;
  // State field(s) for dDropDown widget.
  String? dDropDownValue;
  FormFieldController<String>? dDropDownValueController;
  // Stores action output result for [Custom Action - getProductIdByName] action in dDropDown widget.
  int? dProductID;
  // Stores action output result for [Custom Action - convertImagesToWebP] action in Button widget.
  bool? conversionCopy;
  // Stores action output result for [Custom Action - uploadBannerImages] action in Button widget.
  bool? uploadStatus2;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel4;
  // Model for BannerAddedSuccessfully component.
  late BannerAddedSuccessfullyModel bannerAddedSuccessfullyModel1;
  // Model for FailedtoUploadImage component.
  late FailedtoUploadImageModel failedtoUploadImageModel1;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Custom Action - convertImagesToWebP] action in Button widget.
  bool? convertedtowebpdesktop;
  // Stores action output result for [Custom Action - uploadBannerImages] action in Button widget.
  bool? uploadedtosupabasedesktop;
  // Stores action output result for [Custom Action - getProductIdByProductNameAndSeller] action in Button widget.
  int? productiddesktop;
  // Stores action output result for [Custom Action - singleImageToWebP] action in Button widget.
  bool? convertedmobiledesktop;
  // Stores action output result for [Custom Action - uploadSingleBannerImage] action in Button widget.
  bool? uploadmobiledesktop;
  // Stores action output result for [Custom Action - getProductIdByProductNameAndSeller] action in Button widget.
  int? productiddesktop1;
  // Stores action output result for [Custom Action - singleImageToWebP] action in Button widget.
  bool? converteddesktop2;
  // Stores action output result for [Custom Action - uploadSingleBannerImage] action in Button widget.
  bool? uploaddesktop2;
  // Stores action output result for [Custom Action - getProductIdByProductNameAndSeller] action in Button widget.
  int? productid2desktop;
  // State field(s) for mDropDown widget.
  String? mDropDownValue;
  FormFieldController<String>? mDropDownValueController;
  // Stores action output result for [Custom Action - getProductIdByName] action in mDropDown widget.
  int? mProductID;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel5;
  // Model for BannerAddedSuccessfully component.
  late BannerAddedSuccessfullyModel bannerAddedSuccessfullyModel2;
  // Model for FailedtoUploadImage component.
  late FailedtoUploadImageModel failedtoUploadImageModel2;
  // Stores action output result for [Custom Action - convertImagesToWebP] action in Button widget.
  bool? conversion;
  // Stores action output result for [Custom Action - uploadBannerImages] action in Button widget.
  bool? uploadStatusCopy;
  // State field(s) for mProductDropDown widget.
  String? mProductDropDownValue;
  FormFieldController<String>? mProductDropDownValueController;
  // Stores action output result for [Custom Action - getProductIdByName] action in mProductDropDown widget.
  int? productID;
  // Stores action output result for [Custom Action - getBannersByProductName] action in mProductDropDown widget.
  List<String>? bannerLinks;
  // Stores action output result for [Custom Action - convertImagesToWebP] action in Button widget.
  bool? convertedtowebp;
  // Stores action output result for [Custom Action - uploadBannerImages] action in Button widget.
  bool? uploadedtosupabase;
  // Stores action output result for [Custom Action - getProductIdByProductNameAndSeller] action in Button widget.
  int? productid;
  // Stores action output result for [Custom Action - singleImageToWebP] action in Button widget.
  bool? convertedmobile;
  // Stores action output result for [Custom Action - uploadSingleBannerImage] action in Button widget.
  bool? uploadmobile;
  // Stores action output result for [Custom Action - getProductIdByProductNameAndSeller] action in Button widget.
  int? productid1;
  // Stores action output result for [Custom Action - singleImageToWebP] action in Button widget.
  bool? converteddesktop;
  // Stores action output result for [Custom Action - uploadSingleBannerImage] action in Button widget.
  bool? uploaddesktop;
  // Stores action output result for [Custom Action - getProductIdByProductNameAndSeller] action in Button widget.
  int? productid2;
  // Stores action output result for [Custom Action - getTopDealProductIDs] action in Container widget.
  List<int>? tDids;
  // Stores action output result for [Custom Action - getFeaturedOfferProductIDs] action in Container widget.
  List<int>? fOids;
  // Stores action output result for [Custom Action - getNewArrivalProductIDs] action in Container widget.
  List<int>? nAids;
  // Stores action output result for [Custom Action - fetchPhoneBannerByEmail] action in Button widget.
  String? imageurl;

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
    addProductFailedModel4 =
        createModel(context, () => AddProductFailedModel());
    bannerAddedSuccessfullyModel1 =
        createModel(context, () => BannerAddedSuccessfullyModel());
    failedtoUploadImageModel1 =
        createModel(context, () => FailedtoUploadImageModel());
    addProductFailedModel5 =
        createModel(context, () => AddProductFailedModel());
    bannerAddedSuccessfullyModel2 =
        createModel(context, () => BannerAddedSuccessfullyModel());
    failedtoUploadImageModel2 =
        createModel(context, () => FailedtoUploadImageModel());
  }

  @override
  void dispose() {
    dDescriptionFieldFocusNode?.dispose();
    dDescriptionFieldTextController?.dispose();

    dProductNameFieldFocusNode?.dispose();
    dProductNameFieldTextController?.dispose();

    dQuantityFieldFocusNode?.dispose();
    dQuantityFieldTextController?.dispose();

    mOtherCategoryFocusNode1?.dispose();
    mOtherCategoryTextController1?.dispose();

    mOtherSubCategoryFocusNode1?.dispose();
    mOtherSubCategoryTextController1?.dispose();

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
    mproductNameFieldFocusNode?.dispose();
    mproductNameFieldTextController?.dispose();

    mQuantityFieldFocusNode?.dispose();
    mQuantityFieldTextController?.dispose();

    mOtherCategoryFocusNode2?.dispose();
    mOtherCategoryTextController2?.dispose();

    mOtherSubCategoryFocusNode2?.dispose();
    mOtherSubCategoryTextController2?.dispose();

    mProductDescriptionFieldFocusNode?.dispose();
    mProductDescriptionFieldTextController?.dispose();

    mproductModelFieldFocusNode?.dispose();
    mproductModelFieldTextController?.dispose();

    mPriceFieldFocusNode?.dispose();
    mPriceFieldTextController?.dispose();

    mDiscountFieldFocusNode?.dispose();
    mDiscountFieldTextController?.dispose();

    productAddedSuccessfullyModel3.dispose();
    addProductFailedModel3.dispose();
    addProductFailedModel4.dispose();
    bannerAddedSuccessfullyModel1.dispose();
    failedtoUploadImageModel1.dispose();
    addProductFailedModel5.dispose();
    bannerAddedSuccessfullyModel2.dispose();
    failedtoUploadImageModel2.dispose();
  }
}
