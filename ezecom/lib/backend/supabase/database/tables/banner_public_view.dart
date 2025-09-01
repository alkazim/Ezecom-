import '../database.dart';

class BannerPublicViewTable extends SupabaseTable<BannerPublicViewRow> {
  @override
  String get tableName => 'banner_public_view';

  @override
  BannerPublicViewRow createRow(Map<String, dynamic> data) =>
      BannerPublicViewRow(data);
}

class BannerPublicViewRow extends SupabaseDataRow {
  BannerPublicViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BannerPublicViewTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get phoneBanner => getField<String>('Phone_Banner');
  set phoneBanner(String? value) => setField<String>('Phone_Banner', value);

  String? get desktopBanner => getField<String>('Desktop_Banner');
  set desktopBanner(String? value) => setField<String>('Desktop_Banner', value);

  int? get productId => getField<int>('Product_id');
  set productId(int? value) => setField<int>('Product_id', value);

  String? get mobileDimensions => getField<String>('Mobile_Dimensions');
  set mobileDimensions(String? value) =>
      setField<String>('Mobile_Dimensions', value);

  String? get desktopDimensions => getField<String>('Desktop_Dimensions');
  set desktopDimensions(String? value) =>
      setField<String>('Desktop_Dimensions', value);

  String? get approval => getField<String>('Approval');
  set approval(String? value) => setField<String>('Approval', value);

  bool? get active => getField<bool>('Active');
  set active(bool? value) => setField<bool>('Active', value);

  dynamic? get organization => getField<dynamic>('Organization');
  set organization(dynamic? value) => setField<dynamic>('Organization', value);
}
