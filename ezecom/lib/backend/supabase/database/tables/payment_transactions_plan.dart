import '../database.dart';

class PaymentTransactionsPlanTable
    extends SupabaseTable<PaymentTransactionsPlanRow> {
  @override
  String get tableName => 'Payment_Transactions_Plan';

  @override
  PaymentTransactionsPlanRow createRow(Map<String, dynamic> data) =>
      PaymentTransactionsPlanRow(data);
}

class PaymentTransactionsPlanRow extends SupabaseDataRow {
  PaymentTransactionsPlanRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PaymentTransactionsPlanTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String get sellerCompanyEmail => getField<String>('Seller_Company_Email')!;
  set sellerCompanyEmail(String value) =>
      setField<String>('Seller_Company_Email', value);

  String get purchasedPlanName => getField<String>('Purchased_Plan_Name')!;
  set purchasedPlanName(String value) =>
      setField<String>('Purchased_Plan_Name', value);

  double get amountPaid => getField<double>('Amount_Paid')!;
  set amountPaid(double value) => setField<double>('Amount_Paid', value);

  String get currency => getField<String>('Currency')!;
  set currency(String value) => setField<String>('Currency', value);

  String get paymentGateway => getField<String>('Payment_Gateway')!;
  set paymentGateway(String value) =>
      setField<String>('Payment_Gateway', value);

  String? get gatewayOrderID => getField<String>('Gateway_Order_ID');
  set gatewayOrderID(String? value) =>
      setField<String>('Gateway_Order_ID', value);

  String? get gatewayTransactionID =>
      getField<String>('Gateway_Transaction_ID');
  set gatewayTransactionID(String? value) =>
      setField<String>('Gateway_Transaction_ID', value);

  String get transactionStatus => getField<String>('Transaction_Status')!;
  set transactionStatus(String value) =>
      setField<String>('Transaction_Status', value);

  dynamic? get gatewayRawResponse => getField<dynamic>('Gateway_Raw_Response');
  set gatewayRawResponse(dynamic? value) =>
      setField<dynamic>('Gateway_Raw_Response', value);

  String? get errorMessage => getField<String>('Error_Message');
  set errorMessage(String? value) => setField<String>('Error_Message', value);

  String get transactionToken => getField<String>('transaction_token')!;
  set transactionToken(String value) =>
      setField<String>('transaction_token', value);

  double? get yearPlan => getField<double>('Year_plan');
  set yearPlan(double? value) => setField<double>('Year_plan', value);

  double? get noOfProducts => getField<double>('No_of_Products');
  set noOfProducts(double? value) => setField<double>('No_of_Products', value);

  double? get noOfBanners => getField<double>('No_of_Banners');
  set noOfBanners(double? value) => setField<double>('No_of_Banners', value);

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

  dynamic? get phonePeCallbackResponse =>
      getField<dynamic>('PhonePe_Callback_Response');
  set phonePeCallbackResponse(dynamic? value) =>
      setField<dynamic>('PhonePe_Callback_Response', value);

  String? get authID => getField<String>('Auth_ID');
  set authID(String? value) => setField<String>('Auth_ID', value);
}
