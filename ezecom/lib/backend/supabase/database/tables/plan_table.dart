import '../database.dart';

class PlanTableTable extends SupabaseTable<PlanTableRow> {
  @override
  String get tableName => 'Plan_Table';

  @override
  PlanTableRow createRow(Map<String, dynamic> data) => PlanTableRow(data);
}

class PlanTableRow extends SupabaseDataRow {
  PlanTableRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlanTableTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get planName => getField<String>('Plan_Name');
  set planName(String? value) => setField<String>('Plan_Name', value);

  double? get price => getField<double>('Price');
  set price(double? value) => setField<double>('Price', value);

  String? get planDetails => getField<String>('Plan_Details');
  set planDetails(String? value) => setField<String>('Plan_Details', value);

  double? get noOfProducts => getField<double>('No_of_Products');
  set noOfProducts(double? value) => setField<double>('No_of_Products', value);

  double? get noOfBanners => getField<double>('No_of_Banners');
  set noOfBanners(double? value) => setField<double>('No_of_Banners', value);

  double? get yearMembership => getField<double>('Year_Membership');
  set yearMembership(double? value) =>
      setField<double>('Year_Membership', value);

  double? get indianPrice => getField<double>('Indian_Price');
  set indianPrice(double? value) => setField<double>('Indian_Price', value);

  double get gSTDefault => getField<double>('GST_default')!;
  set gSTDefault(double value) => setField<double>('GST_default', value);
}
