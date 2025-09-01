import '../database.dart';

class BannerTableTable extends SupabaseTable<BannerTableRow> {
  @override
  String get tableName => 'Banner_table';

  @override
  BannerTableRow createRow(Map<String, dynamic> data) => BannerTableRow(data);
}

class BannerTableRow extends SupabaseDataRow {
  BannerTableRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BannerTableTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get phoneBanner => getField<String>('Phone_Banner');
  set phoneBanner(String? value) => setField<String>('Phone_Banner', value);

  String? get desktopBanner => getField<String>('Desktop_Banner');
  set desktopBanner(String? value) => setField<String>('Desktop_Banner', value);

  int? get productId => getField<int>('Product_id');
  set productId(int? value) => setField<int>('Product_id', value);

  String? get sellerEmail => getField<String>('Seller_Email');
  set sellerEmail(String? value) => setField<String>('Seller_Email', value);

  bool? get active => getField<bool>('Active');
  set active(bool? value) => setField<bool>('Active', value);

  String? get mobileDimensions => getField<String>('Mobile_Dimensions');
  set mobileDimensions(String? value) =>
      setField<String>('Mobile_Dimensions', value);

  String? get desktopDimensions => getField<String>('Desktop_Dimensions');
  set desktopDimensions(String? value) =>
      setField<String>('Desktop_Dimensions', value);

  String? get approval => getField<String>('Approval');
  set approval(String? value) => setField<String>('Approval', value);

  dynamic? get organization => getField<dynamic>('Organization');
  set organization(dynamic? value) => setField<dynamic>('Organization', value);

  String? get authID => getField<String>('Auth_ID');
  set authID(String? value) => setField<String>('Auth_ID', value);
}
