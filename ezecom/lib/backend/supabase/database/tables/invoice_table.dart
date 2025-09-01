import '../database.dart';

class InvoiceTableTable extends SupabaseTable<InvoiceTableRow> {
  @override
  String get tableName => 'Invoice_Table';

  @override
  InvoiceTableRow createRow(Map<String, dynamic> data) => InvoiceTableRow(data);
}

class InvoiceTableRow extends SupabaseDataRow {
  InvoiceTableRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => InvoiceTableTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get invoiceId => getField<String>('Invoice_id');
  set invoiceId(String? value) => setField<String>('Invoice_id', value);

  String? get address => getField<String>('Address');
  set address(String? value) => setField<String>('Address', value);

  double? get totalAmount => getField<double>('Total_Amount');
  set totalAmount(double? value) => setField<double>('Total_Amount', value);

  double? get tax => getField<double>('Tax_%');
  set tax(double? value) => setField<double>('Tax_%', value);

  double? get quantity => getField<double>('Quantity');
  set quantity(double? value) => setField<double>('Quantity', value);

  dynamic? get productsDetails => getField<dynamic>('Products_details');
  set productsDetails(dynamic? value) =>
      setField<dynamic>('Products_details', value);

  String? get buyerMail => getField<String>('Buyer_Mail');
  set buyerMail(String? value) => setField<String>('Buyer_Mail', value);

  String? get authID => getField<String>('Auth_ID');
  set authID(String? value) => setField<String>('Auth_ID', value);
}
