import '../database.dart';

class EnquiryTableFactoryThroughTable
    extends SupabaseTable<EnquiryTableFactoryThroughRow> {
  @override
  String get tableName => 'Enquiry_Table_FactoryThrough';

  @override
  EnquiryTableFactoryThroughRow createRow(Map<String, dynamic> data) =>
      EnquiryTableFactoryThroughRow(data);
}

class EnquiryTableFactoryThroughRow extends SupabaseDataRow {
  EnquiryTableFactoryThroughRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => EnquiryTableFactoryThroughTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get productName => getField<String>('Product_Name');
  set productName(String? value) => setField<String>('Product_Name', value);

  double? get quantity => getField<double>('Quantity');
  set quantity(double? value) => setField<double>('Quantity', value);

  String? get buyerName => getField<String>('Buyer_Name');
  set buyerName(String? value) => setField<String>('Buyer_Name', value);

  String? get contactNo => getField<String>('Contact_no');
  set contactNo(String? value) => setField<String>('Contact_no', value);

  String? get paymentStatus => getField<String>('Payment_Status');
  set paymentStatus(String? value) => setField<String>('Payment_Status', value);

  String? get sellerName => getField<String>('Seller_Name');
  set sellerName(String? value) => setField<String>('Seller_Name', value);

  int? get productId => getField<int>('Product_Id');
  set productId(int? value) => setField<int>('Product_Id', value);

  String? get enquiryID => getField<String>('Enquiry_ID');
  set enquiryID(String? value) => setField<String>('Enquiry_ID', value);

  String? get buyerEmail => getField<String>('Buyer_Email');
  set buyerEmail(String? value) => setField<String>('Buyer_Email', value);

  double? get totalPrice => getField<double>('Total_Price');
  set totalPrice(double? value) => setField<double>('Total_Price', value);

  double? get gSTTotalPrice => getField<double>('GST_Total_Price');
  set gSTTotalPrice(double? value) =>
      setField<double>('GST_Total_Price', value);

  String? get sellerEmail => getField<String>('Seller_Email');
  set sellerEmail(String? value) => setField<String>('Seller_Email', value);

  double? get productActualPrice => getField<double>('Product_Actual_Price');
  set productActualPrice(double? value) =>
      setField<double>('Product_Actual_Price', value);

  String? get paypalOrderID => getField<String>('PaypalOrder_ID');
  set paypalOrderID(String? value) => setField<String>('PaypalOrder_ID', value);

  String? get transID => getField<String>('Trans_ID');
  set transID(String? value) => setField<String>('Trans_ID', value);

  double? get paypalprice => getField<double>('Paypalprice');
  set paypalprice(double? value) => setField<double>('Paypalprice', value);

  bool get isEmailSent => getField<bool>('is_email_sent')!;
  set isEmailSent(bool value) => setField<bool>('is_email_sent', value);

  String? get paymentMethod => getField<String>('Payment_Method');
  set paymentMethod(String? value) => setField<String>('Payment_Method', value);

  List<dynamic> get phonepayCallbackResponse =>
      getListField<dynamic>('Phonepay_callback_Response');
  set phonepayCallbackResponse(List<dynamic>? value) =>
      setListField<dynamic>('Phonepay_callback_Response', value);

  String? get phonePeSessionToken => getField<String>('PhonePe_Session_Token');
  set phonePeSessionToken(String? value) =>
      setField<String>('PhonePe_Session_Token', value);

  DateTime? get phonePeSessionExpiresAt =>
      getField<DateTime>('PhonePe_Session_Expires_At');
  set phonePeSessionExpiresAt(DateTime? value) =>
      setField<DateTime>('PhonePe_Session_Expires_At', value);

  bool? get phonePeSessionIsUsed => getField<bool>('PhonePe_Session_Is_Used');
  set phonePeSessionIsUsed(bool? value) =>
      setField<bool>('PhonePe_Session_Is_Used', value);

  String? get paymentInitiationPlatform =>
      getField<String>('Payment_Initiation_Platform');
  set paymentInitiationPlatform(String? value) =>
      setField<String>('Payment_Initiation_Platform', value);

  String? get authID => getField<String>('Auth_ID');
  set authID(String? value) => setField<String>('Auth_ID', value);

  String? get sellerAuthID => getField<String>('Seller_Auth_ID');
  set sellerAuthID(String? value) => setField<String>('Seller_Auth_ID', value);
}
