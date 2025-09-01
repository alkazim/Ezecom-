import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/accept_terms_and_condition_widget.dart';
import '/components/add_product_failed_widget.dart';
import '/components/passworddoesnotmatch_widget.dart';
import '/components/privacy_policy_component_widget.dart';
import '/components/terms_and_condition_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'create_account_buyer_widget.dart' show CreateAccountBuyerWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class CreateAccountBuyerModel
    extends FlutterFlowModel<CreateAccountBuyerWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for bEmailField widget.
  FocusNode? bEmailFieldFocusNode;
  TextEditingController? bEmailFieldTextController;
  String? Function(BuildContext, String?)? bEmailFieldTextControllerValidator;
  // State field(s) for bPasswordField widget.
  FocusNode? bPasswordFieldFocusNode;
  TextEditingController? bPasswordFieldTextController;
  late bool bPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      bPasswordFieldTextControllerValidator;
  // State field(s) for bConfirmPasswordField widget.
  FocusNode? bConfirmPasswordFieldFocusNode;
  TextEditingController? bConfirmPasswordFieldTextController;
  late bool bConfirmPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      bConfirmPasswordFieldTextControllerValidator;
  // State field(s) for bContactPersonNameField widget.
  FocusNode? bContactPersonNameFieldFocusNode;
  TextEditingController? bContactPersonNameFieldTextController;
  String? Function(BuildContext, String?)?
      bContactPersonNameFieldTextControllerValidator;
  // State field(s) for bContactNumberField widget.
  FocusNode? bContactNumberFieldFocusNode;
  TextEditingController? bContactNumberFieldTextController;
  String? Function(BuildContext, String?)?
      bContactNumberFieldTextControllerValidator;
  // State field(s) for CompnayRegistrationnumber widget.
  FocusNode? compnayRegistrationnumberFocusNode;
  TextEditingController? compnayRegistrationnumberTextController;
  String? Function(BuildContext, String?)?
      compnayRegistrationnumberTextControllerValidator;
  // State field(s) for bCompanyNameField widget.
  FocusNode? bCompanyNameFieldFocusNode;
  TextEditingController? bCompanyNameFieldTextController;
  String? Function(BuildContext, String?)?
      bCompanyNameFieldTextControllerValidator;
  // State field(s) for bCompanyAddress widget.
  FocusNode? bCompanyAddressFocusNode;
  TextEditingController? bCompanyAddressTextController;
  String? Function(BuildContext, String?)?
      bCompanyAddressTextControllerValidator;
  // State field(s) for bTaxRegistrationNumber widget.
  FocusNode? bTaxRegistrationNumberFocusNode;
  TextEditingController? bTaxRegistrationNumberTextController;
  String? Function(BuildContext, String?)?
      bTaxRegistrationNumberTextControllerValidator;
  // State field(s) for bbImportExportCertificateNumber widget.
  FocusNode? bbImportExportCertificateNumberFocusNode;
  TextEditingController? bbImportExportCertificateNumberTextController;
  String? Function(BuildContext, String?)?
      bbImportExportCertificateNumberTextControllerValidator;
  // State field(s) for acceptCheckbox widget.
  bool? acceptCheckboxValue;
  // Stores action output result for [Custom Action - registerUserWithApproval] action in Button widget.
  String? hashedpass;
  // Stores action output result for [Custom Action - uploadtosupabasebuyer] action in Button widget.
  String? uploadStatusBuyer;
  // Stores action output result for [Custom Action - assignAuthId] action in Button widget.
  bool? assignAuthID;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel1;
  // Model for Passworddoesnotmatch component.
  late PassworddoesnotmatchModel passworddoesnotmatchModel1;
  // Model for AcceptTermsAndCondition component.
  late AcceptTermsAndConditionModel acceptTermsAndConditionModel1;
  // State field(s) for dEmailField widget.
  FocusNode? dEmailFieldFocusNode;
  TextEditingController? dEmailFieldTextController;
  String? Function(BuildContext, String?)? dEmailFieldTextControllerValidator;
  // State field(s) for dPasswordField widget.
  FocusNode? dPasswordFieldFocusNode;
  TextEditingController? dPasswordFieldTextController;
  late bool dPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      dPasswordFieldTextControllerValidator;
  // State field(s) for dConfirmPasswordField widget.
  FocusNode? dConfirmPasswordFieldFocusNode;
  TextEditingController? dConfirmPasswordFieldTextController;
  late bool dConfirmPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      dConfirmPasswordFieldTextControllerValidator;
  // State field(s) for dCompanyNameField widget.
  FocusNode? dCompanyNameFieldFocusNode;
  TextEditingController? dCompanyNameFieldTextController;
  String? Function(BuildContext, String?)?
      dCompanyNameFieldTextControllerValidator;
  // State field(s) for dTaxRegistrationNumber widget.
  FocusNode? dTaxRegistrationNumberFocusNode;
  TextEditingController? dTaxRegistrationNumberTextController;
  String? Function(BuildContext, String?)?
      dTaxRegistrationNumberTextControllerValidator;
  // State field(s) for dContactPersonNameField widget.
  FocusNode? dContactPersonNameFieldFocusNode;
  TextEditingController? dContactPersonNameFieldTextController;
  String? Function(BuildContext, String?)?
      dContactPersonNameFieldTextControllerValidator;
  // State field(s) for dContactNumberField widget.
  FocusNode? dContactNumberFieldFocusNode;
  TextEditingController? dContactNumberFieldTextController;
  String? Function(BuildContext, String?)?
      dContactNumberFieldTextControllerValidator;
  // State field(s) for dCompnayRegistrationnumber widget.
  FocusNode? dCompnayRegistrationnumberFocusNode;
  TextEditingController? dCompnayRegistrationnumberTextController;
  String? Function(BuildContext, String?)?
      dCompnayRegistrationnumberTextControllerValidator;
  // State field(s) for dCompanyAddress widget.
  FocusNode? dCompanyAddressFocusNode;
  TextEditingController? dCompanyAddressTextController;
  String? Function(BuildContext, String?)?
      dCompanyAddressTextControllerValidator;
  // State field(s) for dImportExportCertificateNumber widget.
  FocusNode? dImportExportCertificateNumberFocusNode;
  TextEditingController? dImportExportCertificateNumberTextController;
  String? Function(BuildContext, String?)?
      dImportExportCertificateNumberTextControllerValidator;
  bool isDataUploading_uploadDataAoi = false;
  FFUploadedFile uploadedLocalFile_uploadDataAoi =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataAoi = '';

  // State field(s) for dacceptCheckbox widget.
  bool? dacceptCheckboxValue;
  // Stores action output result for [Custom Action - uploadtosupabasebuyer] action in Button widget.
  String? duploadStatusBuyer;
  // Stores action output result for [Custom Action - assignAuthId] action in Button widget.
  bool? dassignAuthID;
  // Model for AcceptTermsAndCondition component.
  late AcceptTermsAndConditionModel acceptTermsAndConditionModel2;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel2;
  // Model for Passworddoesnotmatch component.
  late PassworddoesnotmatchModel passworddoesnotmatchModel2;
  // Model for AcceptTermsAndCondition component.
  late AcceptTermsAndConditionModel acceptTermsAndConditionModel3;

  @override
  void initState(BuildContext context) {
    bPasswordFieldVisibility = false;
    bConfirmPasswordFieldVisibility = false;
    addProductFailedModel1 =
        createModel(context, () => AddProductFailedModel());
    passworddoesnotmatchModel1 =
        createModel(context, () => PassworddoesnotmatchModel());
    acceptTermsAndConditionModel1 =
        createModel(context, () => AcceptTermsAndConditionModel());
    dPasswordFieldVisibility = false;
    dConfirmPasswordFieldVisibility = false;
    acceptTermsAndConditionModel2 =
        createModel(context, () => AcceptTermsAndConditionModel());
    addProductFailedModel2 =
        createModel(context, () => AddProductFailedModel());
    passworddoesnotmatchModel2 =
        createModel(context, () => PassworddoesnotmatchModel());
    acceptTermsAndConditionModel3 =
        createModel(context, () => AcceptTermsAndConditionModel());
  }

  @override
  void dispose() {
    bEmailFieldFocusNode?.dispose();
    bEmailFieldTextController?.dispose();

    bPasswordFieldFocusNode?.dispose();
    bPasswordFieldTextController?.dispose();

    bConfirmPasswordFieldFocusNode?.dispose();
    bConfirmPasswordFieldTextController?.dispose();

    bContactPersonNameFieldFocusNode?.dispose();
    bContactPersonNameFieldTextController?.dispose();

    bContactNumberFieldFocusNode?.dispose();
    bContactNumberFieldTextController?.dispose();

    compnayRegistrationnumberFocusNode?.dispose();
    compnayRegistrationnumberTextController?.dispose();

    bCompanyNameFieldFocusNode?.dispose();
    bCompanyNameFieldTextController?.dispose();

    bCompanyAddressFocusNode?.dispose();
    bCompanyAddressTextController?.dispose();

    bTaxRegistrationNumberFocusNode?.dispose();
    bTaxRegistrationNumberTextController?.dispose();

    bbImportExportCertificateNumberFocusNode?.dispose();
    bbImportExportCertificateNumberTextController?.dispose();

    addProductFailedModel1.dispose();
    passworddoesnotmatchModel1.dispose();
    acceptTermsAndConditionModel1.dispose();
    dEmailFieldFocusNode?.dispose();
    dEmailFieldTextController?.dispose();

    dPasswordFieldFocusNode?.dispose();
    dPasswordFieldTextController?.dispose();

    dConfirmPasswordFieldFocusNode?.dispose();
    dConfirmPasswordFieldTextController?.dispose();

    dCompanyNameFieldFocusNode?.dispose();
    dCompanyNameFieldTextController?.dispose();

    dTaxRegistrationNumberFocusNode?.dispose();
    dTaxRegistrationNumberTextController?.dispose();

    dContactPersonNameFieldFocusNode?.dispose();
    dContactPersonNameFieldTextController?.dispose();

    dContactNumberFieldFocusNode?.dispose();
    dContactNumberFieldTextController?.dispose();

    dCompnayRegistrationnumberFocusNode?.dispose();
    dCompnayRegistrationnumberTextController?.dispose();

    dCompanyAddressFocusNode?.dispose();
    dCompanyAddressTextController?.dispose();

    dImportExportCertificateNumberFocusNode?.dispose();
    dImportExportCertificateNumberTextController?.dispose();

    acceptTermsAndConditionModel2.dispose();
    addProductFailedModel2.dispose();
    passworddoesnotmatchModel2.dispose();
    acceptTermsAndConditionModel3.dispose();
  }
}
