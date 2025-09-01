import '/backend/supabase/supabase.dart';
import '/components/no_account_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'home_page_seller2_widget.dart' show HomePageSeller2Widget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class HomePageSeller2Model extends FlutterFlowModel<HomePageSeller2Widget> {
  ///  State fields for stateful widgets in this page.

  Stream<List<PublicProductsViewRow>>? rowSupabaseStream1;
  Stream<List<PublicProductsViewRow>>? rowSupabaseStream2;
  Stream<List<PublicProductsViewRow>>? rowSupabaseStream3;
  Stream<List<PublicProductsViewRow>>? rowSupabaseStream4;
  Stream<List<PublicProductsViewRow>>? rowSupabaseStream5;
  Stream<List<PublicProductsViewRow>>? rowSupabaseStream6;
  // State field(s) for SearchField widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;
  // Stores action output result for [Custom Action - searchProducts] action in SearchField widget.
  List<int>? productIDs;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFieldFocusNode?.dispose();
    searchFieldTextController?.dispose();
  }
}
