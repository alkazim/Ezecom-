import '../database.dart';

class SellerUserTable extends SupabaseTable<SellerUserRow> {
  @override
  String get tableName => 'Seller_User';

  @override
  SellerUserRow createRow(Map<String, dynamic> data) => SellerUserRow(data);
}

class SellerUserRow extends SupabaseDataRow {
  SellerUserRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SellerUserTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get companyName => getField<String>('Company_Name');
  set companyName(String? value) => setField<String>('Company_Name', value);

  String? get companyAddress => getField<String>('Company_Address');
  set companyAddress(String? value) =>
      setField<String>('Company_Address', value);

  double? get companyContactNumber =>
      getField<double>('Company_Contact_Number');
  set companyContactNumber(double? value) =>
      setField<double>('Company_Contact_Number', value);

  String? get companyEmail => getField<String>('Company_Email');
  set companyEmail(String? value) => setField<String>('Company_Email', value);

  String? get ownerDirectorIDNumber =>
      getField<String>('Owner/Director_ID_Number');
  set ownerDirectorIDNumber(String? value) =>
      setField<String>('Owner/Director_ID_Number', value);

  String? get contactPersonName => getField<String>('Contact_Person_Name');
  set contactPersonName(String? value) =>
      setField<String>('Contact_Person_Name', value);

  double? get contactPersonMobileNumber =>
      getField<double>('Contact_Person_Mobile_Number');
  set contactPersonMobileNumber(double? value) =>
      setField<double>('Contact_Person_Mobile_Number', value);

  String? get contactPersonEmail => getField<String>('Contact_Person_Email');
  set contactPersonEmail(String? value) =>
      setField<String>('Contact_Person_Email', value);

  String? get companyRegistrationCertificate =>
      getField<String>('Company_Registration_Certificate');
  set companyRegistrationCertificate(String? value) =>
      setField<String>('Company_Registration_Certificate', value);

  String? get taxRegistrationCertificate =>
      getField<String>('Tax_Registration_Certificate');
  set taxRegistrationCertificate(String? value) =>
      setField<String>('Tax_Registration_Certificate', value);

  String? get ownerDirectorIDCard => getField<String>('Owner/Director_ID_Card');
  set ownerDirectorIDCard(String? value) =>
      setField<String>('Owner/Director_ID_Card', value);

  String? get factoryCompanyImage => getField<String>('Factory/Company_image');
  set factoryCompanyImage(String? value) =>
      setField<String>('Factory/Company_image', value);

  String? get importExportCertificate =>
      getField<String>('Import_Export_Certificate');
  set importExportCertificate(String? value) =>
      setField<String>('Import_Export_Certificate', value);

  String? get logoRegistrationCertificate =>
      getField<String>('Logo_Registration_Certificate');
  set logoRegistrationCertificate(String? value) =>
      setField<String>('Logo_Registration_Certificate', value);

  String? get trademarkOrLogoImage =>
      getField<String>('Trademark_or_Logo_Image');
  set trademarkOrLogoImage(String? value) =>
      setField<String>('Trademark_or_Logo_Image', value);

  String? get role => getField<String>('Role');
  set role(String? value) => setField<String>('Role', value);

  String? get subscriptionPlan => getField<String>('Subscription_Plan');
  set subscriptionPlan(String? value) =>
      setField<String>('Subscription_Plan', value);

  String? get paymentStatus => getField<String>('payment_status');
  set paymentStatus(String? value) => setField<String>('payment_status', value);

  double? get planPrice => getField<double>('Plan_Price');
  set planPrice(double? value) => setField<double>('Plan_Price', value);

  double? get noOfProducts => getField<double>('No_of_Products');
  set noOfProducts(double? value) => setField<double>('No_of_Products', value);

  int? get maximumProduct => getField<int>('Maximum_Product');
  set maximumProduct(int? value) => setField<int>('Maximum_Product', value);

  double? get shopImageBanner => getField<double>('Shop_Image_Banner');
  set shopImageBanner(double? value) =>
      setField<double>('Shop_Image_Banner', value);

  DateTime? get timePeriod => getField<DateTime>('Time_Period');
  set timePeriod(DateTime? value) => setField<DateTime>('Time_Period', value);

  bool get active => getField<bool>('Active')!;
  set active(bool value) => setField<bool>('Active', value);

  String? get paidOnDate => getField<String>('Paid_OnDate');
  set paidOnDate(String? value) => setField<String>('Paid_OnDate', value);

  bool? get expiryCheck => getField<bool>('Expiry_Check');
  set expiryCheck(bool? value) => setField<bool>('Expiry_Check', value);

  String? get lastTransactionToken =>
      getField<String>('Last_Transaction_Token');
  set lastTransactionToken(String? value) =>
      setField<String>('Last_Transaction_Token', value);

  String? get authID => getField<String>('Auth_ID');
  set authID(String? value) => setField<String>('Auth_ID', value);
}
