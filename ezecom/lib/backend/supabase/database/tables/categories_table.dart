import '../database.dart';

class CategoriesTableTable extends SupabaseTable<CategoriesTableRow> {
  @override
  String get tableName => 'Categories_Table';

  @override
  CategoriesTableRow createRow(Map<String, dynamic> data) =>
      CategoriesTableRow(data);
}

class CategoriesTableRow extends SupabaseDataRow {
  CategoriesTableRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CategoriesTableTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int get id => getField<int>('ID')!;
  set id(int value) => setField<int>('ID', value);

  String? get categoryName => getField<String>('Category_Name');
  set categoryName(String? value) => setField<String>('Category_Name', value);

  String get categoryID => getField<String>('Category_ID')!;
  set categoryID(String value) => setField<String>('Category_ID', value);

  String? get imageURL => getField<String>('ImageURL');
  set imageURL(String? value) => setField<String>('ImageURL', value);
}
