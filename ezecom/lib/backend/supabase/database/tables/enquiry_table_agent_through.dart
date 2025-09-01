import '../database.dart';

class EnquiryTableAgentThroughTable
    extends SupabaseTable<EnquiryTableAgentThroughRow> {
  @override
  String get tableName => 'Enquiry_Table_AgentThrough';

  @override
  EnquiryTableAgentThroughRow createRow(Map<String, dynamic> data) =>
      EnquiryTableAgentThroughRow(data);
}

class EnquiryTableAgentThroughRow extends SupabaseDataRow {
  EnquiryTableAgentThroughRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => EnquiryTableAgentThroughTable();

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

  String? get sellerEmail => getField<String>('Seller_Email');
  set sellerEmail(String? value) => setField<String>('Seller_Email', value);

  String? get status => getField<String>('Status');
  set status(String? value) => setField<String>('Status', value);

  int? get productId => getField<int>('Product_id');
  set productId(int? value) => setField<int>('Product_id', value);

  String get enquiryID => getField<String>('Enquiry_ID')!;
  set enquiryID(String value) => setField<String>('Enquiry_ID', value);

  double? get totalPrice => getField<double>('Total_Price');
  set totalPrice(double? value) => setField<double>('Total_Price', value);

  String? get buyerMail => getField<String>('Buyer_Mail');
  set buyerMail(String? value) => setField<String>('Buyer_Mail', value);

  double? get unitPrice => getField<double>('Unit_price');
  set unitPrice(double? value) => setField<double>('Unit_price', value);

  String? get authID => getField<String>('Auth_ID');
  set authID(String? value) => setField<String>('Auth_ID', value);
}
