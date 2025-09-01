import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/accept_terms_and_condition_widget.dart';
import '/components/add_product_failed_widget.dart';
import '/components/email_already_exist_widget.dart';
import '/components/passworddoesnotmatch_widget.dart';
import '/components/privacy_policy_component_widget.dart';
import '/components/terms_and_condition_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'create_account_seller_widget.dart' show CreateAccountSellerWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class CreateAccountSellerModel
    extends FlutterFlowModel<CreateAccountSellerWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for sCompanyNameField widget.
  FocusNode? sCompanyNameFieldFocusNode;
  TextEditingController? sCompanyNameFieldTextController;
  String? Function(BuildContext, String?)?
      sCompanyNameFieldTextControllerValidator;
  // State field(s) for sCompanyAddressField widget.
  FocusNode? sCompanyAddressFieldFocusNode;
  TextEditingController? sCompanyAddressFieldTextController;
  String? Function(BuildContext, String?)?
      sCompanyAddressFieldTextControllerValidator;
  // State field(s) for sCompanyContactNumberField widget.
  FocusNode? sCompanyContactNumberFieldFocusNode;
  TextEditingController? sCompanyContactNumberFieldTextController;
  String? Function(BuildContext, String?)?
      sCompanyContactNumberFieldTextControllerValidator;
  // State field(s) for sCompanyEmailField widget.
  FocusNode? sCompanyEmailFieldFocusNode;
  TextEditingController? sCompanyEmailFieldTextController;
  String? Function(BuildContext, String?)?
      sCompanyEmailFieldTextControllerValidator;
  // State field(s) for sPasswordField widget.
  FocusNode? sPasswordFieldFocusNode;
  TextEditingController? sPasswordFieldTextController;
  late bool sPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      sPasswordFieldTextControllerValidator;
  // State field(s) for sConfirmPasswordField widget.
  FocusNode? sConfirmPasswordFieldFocusNode;
  TextEditingController? sConfirmPasswordFieldTextController;
  late bool sConfirmPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      sConfirmPasswordFieldTextControllerValidator;
  // State field(s) for sOwnerDirectorIDNumberField widget.
  FocusNode? sOwnerDirectorIDNumberFieldFocusNode;
  TextEditingController? sOwnerDirectorIDNumberFieldTextController;
  String? Function(BuildContext, String?)?
      sOwnerDirectorIDNumberFieldTextControllerValidator;
  // State field(s) for sContactPersonNameField widget.
  FocusNode? sContactPersonNameFieldFocusNode;
  TextEditingController? sContactPersonNameFieldTextController;
  String? Function(BuildContext, String?)?
      sContactPersonNameFieldTextControllerValidator;
  // State field(s) for sContactPersonEmailField widget.
  FocusNode? sContactPersonEmailFieldFocusNode;
  TextEditingController? sContactPersonEmailFieldTextController;
  String? Function(BuildContext, String?)?
      sContactPersonEmailFieldTextControllerValidator;
  // State field(s) for sContactPersonMobileNumberField widget.
  FocusNode? sContactPersonMobileNumberFieldFocusNode;
  TextEditingController? sContactPersonMobileNumberFieldTextController;
  String? Function(BuildContext, String?)?
      sContactPersonMobileNumberFieldTextControllerValidator;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel1;
  // Model for Passworddoesnotmatch component.
  late PassworddoesnotmatchModel passworddoesnotmatchModel1;
  // Model for AcceptTermsAndCondition component.
  late AcceptTermsAndConditionModel acceptTermsAndConditionModel1;
  // Model for EmailAlreadyExist component.
  late EmailAlreadyExistModel emailAlreadyExistModel1;
  // State field(s) for acceptCheckbox widget.
  bool? acceptCheckboxValue;
  // Stores action output result for [Custom Action - checkEmailAvailability] action in Button widget.
  String? checkEmailInAuth;
  // Stores action output result for [Custom Action - uploadMultipleFilesToSupabase] action in Button widget.
  String? uploadStatus;
  // Stores action output result for [Custom Action - assignAuthId] action in Button widget.
  bool? assignAuthID;
  // State field(s) for dCompanyNameField widget.
  FocusNode? dCompanyNameFieldFocusNode;
  TextEditingController? dCompanyNameFieldTextController;
  String? Function(BuildContext, String?)?
      dCompanyNameFieldTextControllerValidator;
  // State field(s) for dCompanyContactNumberField widget.
  FocusNode? dCompanyContactNumberFieldFocusNode;
  TextEditingController? dCompanyContactNumberFieldTextController;
  String? Function(BuildContext, String?)?
      dCompanyContactNumberFieldTextControllerValidator;
  // State field(s) for dPasswordField widget.
  FocusNode? dPasswordFieldFocusNode;
  TextEditingController? dPasswordFieldTextController;
  late bool dPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      dPasswordFieldTextControllerValidator;
  // State field(s) for dOwnerDirectorIDNumberField widget.
  FocusNode? dOwnerDirectorIDNumberFieldFocusNode;
  TextEditingController? dOwnerDirectorIDNumberFieldTextController;
  String? Function(BuildContext, String?)?
      dOwnerDirectorIDNumberFieldTextControllerValidator;
  // State field(s) for dContactPersonEmailField widget.
  FocusNode? dContactPersonEmailFieldFocusNode;
  TextEditingController? dContactPersonEmailFieldTextController;
  String? Function(BuildContext, String?)?
      dContactPersonEmailFieldTextControllerValidator;
  // State field(s) for dCompanyAddressField widget.
  FocusNode? dCompanyAddressFieldFocusNode;
  TextEditingController? dCompanyAddressFieldTextController;
  String? Function(BuildContext, String?)?
      dCompanyAddressFieldTextControllerValidator;
  // State field(s) for dCompanyEmailField widget.
  FocusNode? dCompanyEmailFieldFocusNode;
  TextEditingController? dCompanyEmailFieldTextController;
  String? Function(BuildContext, String?)?
      dCompanyEmailFieldTextControllerValidator;
  // State field(s) for dConfirmPasswordField widget.
  FocusNode? dConfirmPasswordFieldFocusNode;
  TextEditingController? dConfirmPasswordFieldTextController;
  late bool dConfirmPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      dConfirmPasswordFieldTextControllerValidator;
  // State field(s) for dContactPersonNameField widget.
  FocusNode? dContactPersonNameFieldFocusNode;
  TextEditingController? dContactPersonNameFieldTextController;
  String? Function(BuildContext, String?)?
      dContactPersonNameFieldTextControllerValidator;
  // State field(s) for dContactPersonMobileNumberField widget.
  FocusNode? dContactPersonMobileNumberFieldFocusNode;
  TextEditingController? dContactPersonMobileNumberFieldTextController;
  String? Function(BuildContext, String?)?
      dContactPersonMobileNumberFieldTextControllerValidator;
  // State field(s) for dacceptCheckbox widget.
  bool? dacceptCheckboxValue;
  // Stores action output result for [Custom Action - checkEmailAvailability] action in Button widget.
  String? dcheckEmailInAuthCopy;
  // Stores action output result for [Custom Action - uploadMultipleFilesToSupabase] action in Button widget.
  String? uploadStatusCopy;
  // Stores action output result for [Custom Action - assignAuthId] action in Button widget.
  bool? dassignAuthIDCopy;
  // Model for AddProductFailed component.
  late AddProductFailedModel addProductFailedModel2;
  // Model for Passworddoesnotmatch component.
  late PassworddoesnotmatchModel passworddoesnotmatchModel2;
  // Model for AcceptTermsAndCondition component.
  late AcceptTermsAndConditionModel acceptTermsAndConditionModel2;
  // Model for EmailAlreadyExist component.
  late EmailAlreadyExistModel emailAlreadyExistModel2;

  @override
  void initState(BuildContext context) {
    sPasswordFieldVisibility = false;
    sConfirmPasswordFieldVisibility = false;
    addProductFailedModel1 =
        createModel(context, () => AddProductFailedModel());
    passworddoesnotmatchModel1 =
        createModel(context, () => PassworddoesnotmatchModel());
    acceptTermsAndConditionModel1 =
        createModel(context, () => AcceptTermsAndConditionModel());
    emailAlreadyExistModel1 =
        createModel(context, () => EmailAlreadyExistModel());
    dPasswordFieldVisibility = false;
    dConfirmPasswordFieldVisibility = false;
    addProductFailedModel2 =
        createModel(context, () => AddProductFailedModel());
    passworddoesnotmatchModel2 =
        createModel(context, () => PassworddoesnotmatchModel());
    acceptTermsAndConditionModel2 =
        createModel(context, () => AcceptTermsAndConditionModel());
    emailAlreadyExistModel2 =
        createModel(context, () => EmailAlreadyExistModel());
  }

  @override
  void dispose() {
    sCompanyNameFieldFocusNode?.dispose();
    sCompanyNameFieldTextController?.dispose();

    sCompanyAddressFieldFocusNode?.dispose();
    sCompanyAddressFieldTextController?.dispose();

    sCompanyContactNumberFieldFocusNode?.dispose();
    sCompanyContactNumberFieldTextController?.dispose();

    sCompanyEmailFieldFocusNode?.dispose();
    sCompanyEmailFieldTextController?.dispose();

    sPasswordFieldFocusNode?.dispose();
    sPasswordFieldTextController?.dispose();

    sConfirmPasswordFieldFocusNode?.dispose();
    sConfirmPasswordFieldTextController?.dispose();

    sOwnerDirectorIDNumberFieldFocusNode?.dispose();
    sOwnerDirectorIDNumberFieldTextController?.dispose();

    sContactPersonNameFieldFocusNode?.dispose();
    sContactPersonNameFieldTextController?.dispose();

    sContactPersonEmailFieldFocusNode?.dispose();
    sContactPersonEmailFieldTextController?.dispose();

    sContactPersonMobileNumberFieldFocusNode?.dispose();
    sContactPersonMobileNumberFieldTextController?.dispose();

    addProductFailedModel1.dispose();
    passworddoesnotmatchModel1.dispose();
    acceptTermsAndConditionModel1.dispose();
    emailAlreadyExistModel1.dispose();
    dCompanyNameFieldFocusNode?.dispose();
    dCompanyNameFieldTextController?.dispose();

    dCompanyContactNumberFieldFocusNode?.dispose();
    dCompanyContactNumberFieldTextController?.dispose();

    dPasswordFieldFocusNode?.dispose();
    dPasswordFieldTextController?.dispose();

    dOwnerDirectorIDNumberFieldFocusNode?.dispose();
    dOwnerDirectorIDNumberFieldTextController?.dispose();

    dContactPersonEmailFieldFocusNode?.dispose();
    dContactPersonEmailFieldTextController?.dispose();

    dCompanyAddressFieldFocusNode?.dispose();
    dCompanyAddressFieldTextController?.dispose();

    dCompanyEmailFieldFocusNode?.dispose();
    dCompanyEmailFieldTextController?.dispose();

    dConfirmPasswordFieldFocusNode?.dispose();
    dConfirmPasswordFieldTextController?.dispose();

    dContactPersonNameFieldFocusNode?.dispose();
    dContactPersonNameFieldTextController?.dispose();

    dContactPersonMobileNumberFieldFocusNode?.dispose();
    dContactPersonMobileNumberFieldTextController?.dispose();

    addProductFailedModel2.dispose();
    passworddoesnotmatchModel2.dispose();
    acceptTermsAndConditionModel2.dispose();
    emailAlreadyExistModel2.dispose();
  }
}
