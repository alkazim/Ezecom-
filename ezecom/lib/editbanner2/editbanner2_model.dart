import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'editbanner2_widget.dart' show Editbanner2Widget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Editbanner2Model extends FlutterFlowModel<Editbanner2Widget> {
  ///  Local state fields for this page.

  String phonelink = 'false';

  String desktoplink = 'false';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - fetchPhoneBannerByEmail] action in editbanner2 widget.
  String? phonebanner;
  // Stores action output result for [Custom Action - fetchDesktopBannerByEmail] action in editbanner2 widget.
  String? desktopbanner;
  // Stores action output result for [Custom Action - fetchCurrentProductName] action in editbanner2 widget.
  String? productfoundname;
  // Stores action output result for [Backend Call - Query Rows] action in editbanner2 widget.
  List<ProductsTableRow>? productlist;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
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
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
