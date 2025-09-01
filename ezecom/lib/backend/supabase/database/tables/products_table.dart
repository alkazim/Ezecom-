import '../database.dart';

class ProductsTableTable extends SupabaseTable<ProductsTableRow> {
  @override
  String get tableName => 'Products_Table';

  @override
  ProductsTableRow createRow(Map<String, dynamic> data) =>
      ProductsTableRow(data);
}

class ProductsTableRow extends SupabaseDataRow {
  ProductsTableRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductsTableTable();

  int get productId => getField<int>('Product_id')!;
  set productId(int value) => setField<int>('Product_id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get categoryName => getField<String>('Category_Name');
  set categoryName(String? value) => setField<String>('Category_Name', value);

  String? get description => getField<String>('Description');
  set description(String? value) => setField<String>('Description', value);

  double? get price => getField<double>('Price');
  set price(double? value) => setField<double>('Price', value);

  List<String> get imageURL => getListField<String>('ImageURL');
  set imageURL(List<String>? value) => setListField<String>('ImageURL', value);

  dynamic? get options => getField<dynamic>('Options');
  set options(dynamic? value) => setField<dynamic>('Options', value);

  String? get productName => getField<String>('Product_Name');
  set productName(String? value) => setField<String>('Product_Name', value);

  double? get discount => getField<double>('Discount');
  set discount(double? value) => setField<double>('Discount', value);

  String? get approval => getField<String>('Approval');
  set approval(String? value) => setField<String>('Approval', value);

  List<String> get tags => getListField<String>('Tags');
  set tags(List<String>? value) => setListField<String>('Tags', value);

  String? get role => getField<String>('Role');
  set role(String? value) => setField<String>('Role', value);

  int? get quantity => getField<int>('Quantity');
  set quantity(int? value) => setField<int>('Quantity', value);

  String? get addedBy => getField<String>('Added_by');
  set addedBy(String? value) => setField<String>('Added_by', value);

  dynamic? get status => getField<dynamic>('Status');
  set status(dynamic? value) => setField<dynamic>('Status', value);

  String? get modelN0 => getField<String>('Model_N0');
  set modelN0(String? value) => setField<String>('Model_N0', value);

  String get categoryID => getField<String>('Category_ID')!;
  set categoryID(String value) => setField<String>('Category_ID', value);

  String? get subCategoryID => getField<String>('SubCategory_ID');
  set subCategoryID(String? value) => setField<String>('SubCategory_ID', value);

  double? get discountedPrice => getField<double>('Discounted_Price');
  set discountedPrice(double? value) =>
      setField<double>('Discounted_Price', value);

  String? get subCategoryName => getField<String>('Sub_Category_Name');
  set subCategoryName(String? value) =>
      setField<String>('Sub_Category_Name', value);

  String? get sellerEmail => getField<String>('Seller_Email');
  set sellerEmail(String? value) => setField<String>('Seller_Email', value);

  String? get authID => getField<String>('Auth_ID');
  set authID(String? value) => setField<String>('Auth_ID', value);

  String? get rejectionReason => getField<String>('Rejection_reason');
  set rejectionReason(String? value) =>
      setField<String>('Rejection_reason', value);

  bool? get isDeleted => getField<bool>('Is_deleted');
  set isDeleted(bool? value) => setField<bool>('Is_deleted', value);
}
