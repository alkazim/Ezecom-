import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/no_account_widget.dart';
import '/components/notificationpopup_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkNotificationField] action in HomePage widget.
  bool? noti;
  // Stores action output result for [Custom Action - getUserRole4] action in HomePage widget.
  String? fetchRole;
  // Stores action output result for [Custom Action - checkAccountApproval1] action in HomePage widget.
  String? approvalStatus1;
  // Stores action output result for [Custom Action - getPaymentStatusFromSellerUser] action in HomePage widget.
  String? paymentStatsuSeller;
  // Stores action output result for [Custom Action - checkAccountApproval2] action in HomePage widget.
  String? approvalStatus2;
  // Stores action output result for [Custom Action - getTopDealProductIDs] action in HomePage widget.
  List<int>? tDids;
  // Stores action output result for [Custom Action - getFeaturedOfferProductIDs] action in HomePage widget.
  List<int>? fOids;
  // Stores action output result for [Custom Action - getNewArrivalProductIDs] action in HomePage widget.
  List<int>? nAids;
  // Stores action output result for [Custom Action - getTopDealProductIDs] action in HomePage widget.
  List<int>? tDids1;
  // Stores action output result for [Custom Action - getFeaturedOfferProductIDs] action in HomePage widget.
  List<int>? fOids1;
  // Stores action output result for [Custom Action - getNewArrivalProductIDs] action in HomePage widget.
  List<int>? nAids1;
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
