import '../database.dart';

class OrderDetailsTable extends SupabaseTable<OrderDetailsRow> {
  @override
  String get tableName => 'Order_details';

  @override
  OrderDetailsRow createRow(Map<String, dynamic> data) => OrderDetailsRow(data);
}

class OrderDetailsRow extends SupabaseDataRow {
  OrderDetailsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderDetailsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get companyName => getField<String>('Company_Name');
  set companyName(String? value) => setField<String>('Company_Name', value);

  String? get productName => getField<String>('Product_Name');
  set productName(String? value) => setField<String>('Product_Name', value);

  String? get quantity => getField<String>('Quantity');
  set quantity(String? value) => setField<String>('Quantity', value);

  double? get productPrice => getField<double>('Product_Price');
  set productPrice(double? value) => setField<double>('Product_Price', value);

  String? get orderStatus => getField<String>('Order_Status');
  set orderStatus(String? value) => setField<String>('Order_Status', value);

  int get productId => getField<int>('Product_id')!;
  set productId(int value) => setField<int>('Product_id', value);

  String? get paymentMode => getField<String>('Payment_mode');
  set paymentMode(String? value) => setField<String>('Payment_mode', value);

  String? get purchaseMode => getField<String>('Purchase_mode');
  set purchaseMode(String? value) => setField<String>('Purchase_mode', value);

  String? get paymentStatus => getField<String>('Payment_status');
  set paymentStatus(String? value) => setField<String>('Payment_status', value);

  String? get buyerName => getField<String>('Buyer_name');
  set buyerName(String? value) => setField<String>('Buyer_name', value);

  String? get orderID => getField<String>('order_ID');
  set orderID(String? value) => setField<String>('order_ID', value);

  String? get categoryName => getField<String>('category_Name');
  set categoryName(String? value) => setField<String>('category_Name', value);

  String? get enquiryID => getField<String>('Enquiry_ID');
  set enquiryID(String? value) => setField<String>('Enquiry_ID', value);

  String? get shippingStatus => getField<String>('shipping_status');
  set shippingStatus(String? value) =>
      setField<String>('shipping_status', value);

  String? get shippingMessage => getField<String>('shipping_message');
  set shippingMessage(String? value) =>
      setField<String>('shipping_message', value);

  double? get totalPrice => getField<double>('Total_price');
  set totalPrice(double? value) => setField<double>('Total_price', value);

  String? get authID => getField<String>('Auth_ID');
  set authID(String? value) => setField<String>('Auth_ID', value);

  String? get buyerEmail => getField<String>('Buyer_Email');
  set buyerEmail(String? value) => setField<String>('Buyer_Email', value);

  String? get notes => getField<String>('Notes');
  set notes(String? value) => setField<String>('Notes', value);
}
