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
import 'seller6_banners_copy_widget.dart' show Seller6BannersCopyWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Seller6BannersCopyModel
    extends FlutterFlowModel<Seller6BannersCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getApprovedProductNamesBySellerEmail] action in Seller6BannersCopy widget.
  List<String>? sellerApprovedProductList;
  // State field(s) for dDropDown widget.
  String? dDropDownValue;
  FormFieldController<String>? dDropDownValueController;
  // Stores action output result for [Custom Action - getProductIdByName] action in dDropDown widget.
  int? dProductID;
  // Stores action output result for [Custom Action - convertImagesToWebP] action in Button widget.
  bool? conversionCopy;
  // Stores action output result for [Custom Action - uploadBannerImages] action in Button widget.
  bool? uploadStatusCopyCopyCopy;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel1;
  // Model for BannerAddedSuccessfully component.
  late BannerAddedSuccessfullyModel bannerAddedSuccessfullyModel1;
  // Model for FailedtoUploadImage component.
  late FailedtoUploadImageModel failedtoUploadImageModel1;
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
  bool? uploadStatusCopyCopy;

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
