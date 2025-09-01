import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/add_product_failed_widget.dart';
import '/components/banner_added_successfully_widget.dart';
import '/components/failedto_upload_image_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'seller6_banners_widget.dart' show Seller6BannersWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Seller6BannersModel extends FlutterFlowModel<Seller6BannersWidget> {
  ///  Local state fields for this page.

  String? bannerVisibility = 'null';

  String phonelink = 'false';

  String desktoplink = 'false';

  bool bannerState = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkBannerApprovalStatus] action in Seller6Banners widget.
  String? bannerApprovalStatus;
  // Stores action output result for [Custom Action - getSellerProductsWithBanners] action in Seller6Banners widget.
  List<String>? sellerProductsWithBanners;
  // Stores action output result for [Custom Action - getApprovedProductNamesBySellerEmail] action in Seller6Banners widget.
  List<String>? sellerApprovedProductList;
  // Stores action output result for [Custom Action - fetchCurrentProductName] action in Seller6Banners widget.
  String? productfoundname;
  // Stores action output result for [Custom Action - getProductsBySeller] action in Container widget.
  List<String>? bannerProductList;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel1;
  // Model for BannerAddedSuccessfully component.
  late BannerAddedSuccessfullyModel bannerAddedSuccessfullyModel1;
  // Model for FailedtoUploadImage component.
  late FailedtoUploadImageModel failedtoUploadImageModel1;
  // State field(s) for dDropDown widget.
  String? dDropDownValue;
  FormFieldController<String>? dDropDownValueController;
  // Stores action output result for [Custom Action - getProductIdByName] action in dDropDown widget.
  int? dProductID;
  // Stores action output result for [Custom Action - convertImagesToWebP] action in Button widget.
  bool? conversionCopy;
  // Stores action output result for [Custom Action - uploadBannerImages] action in Button widget.
  bool? uploadStatus2;
  // State field(s) for dDropDownvalue widget.
  String? dDropDownvalueValue;
  FormFieldController<String>? dDropDownvalueValueController;
  // Stores action output result for [Custom Action - getProductIdByName] action in dDropDownvalue widget.
  int? productIDCopy;
  // Stores action output result for [Custom Action - getBannersByProductName] action in dDropDownvalue widget.
  List<String>? bannerLinksd;
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
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Custom Action - convertImagesToWebP] action in Button widget.
  bool? conversionCopy1;
  // Stores action output result for [Custom Action - uploadBannerImages] action in Button widget.
  bool? uploadStatus23;
  // State field(s) for mDropDown widget.
  String? mDropDownValue;
  FormFieldController<String>? mDropDownValueController;
  // Stores action output result for [Custom Action - getProductIdByName] action in mDropDown widget.
  int? mProductID;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel2;
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

  @override
  void initState(BuildContext context) {
    addProductFailedModel1 =
        createModel(context, () => AddProductFailedModel());
    bannerAddedSuccessfullyModel1 =
        createModel(context, () => BannerAddedSuccessfullyModel());
    failedtoUploadImageModel1 =
        createModel(context, () => FailedtoUploadImageModel());
    addProductFailedModel2 =
        createModel(context, () => AddProductFailedModel());
    bannerAddedSuccessfullyModel2 =
        createModel(context, () => BannerAddedSuccessfullyModel());
    failedtoUploadImageModel2 =
        createModel(context, () => FailedtoUploadImageModel());
  }

  @override
  void dispose() {
    addProductFailedModel1.dispose();
    bannerAddedSuccessfullyModel1.dispose();
    failedtoUploadImageModel1.dispose();
    addProductFailedModel2.dispose();
    bannerAddedSuccessfullyModel2.dispose();
    failedtoUploadImageModel2.dispose();
  }
}
