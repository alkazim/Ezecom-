import '../database.dart';

class GSTManufacturePlanDetailsTable
    extends SupabaseTable<GSTManufacturePlanDetailsRow> {
  @override
  String get tableName => '(GST) manufacture_plan_details';

  @override
  GSTManufacturePlanDetailsRow createRow(Map<String, dynamic> data) =>
      GSTManufacturePlanDetailsRow(data);
}

class GSTManufacturePlanDetailsRow extends SupabaseDataRow {
  GSTManufacturePlanDetailsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GSTManufacturePlanDetailsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  double? get planAmount => getField<double>('Plan_amount');
  set planAmount(double? value) => setField<double>('Plan_amount', value);

  String? get name => getField<String>('Name');
  set name(String? value) => setField<String>('Name', value);

  double? get gst => getField<double>('GST');
  set gst(double? value) => setField<double>('GST', value);

  double? get rupeePrice => getField<double>('Rupee_price');
  set rupeePrice(double? value) => setField<double>('Rupee_price', value);
}
