import '../database.dart';

class SubCategoryTableTable extends SupabaseTable<SubCategoryTableRow> {
  @override
  String get tableName => 'Sub_Category_Table';

  @override
  SubCategoryTableRow createRow(Map<String, dynamic> data) =>
      SubCategoryTableRow(data);
}

class SubCategoryTableRow extends SupabaseDataRow {
  SubCategoryTableRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubCategoryTableTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get categoryID => getField<String>('Category_ID');
  set categoryID(String? value) => setField<String>('Category_ID', value);

  String? get subCategoryName => getField<String>('SubCategory_Name');
  set subCategoryName(String? value) =>
      setField<String>('SubCategory_Name', value);

  String? get categoryName => getField<String>('Category_Name');
  set categoryName(String? value) => setField<String>('Category_Name', value);

  String? get subCategoryID => getField<String>('Sub_Category_ID');
  set subCategoryID(String? value) =>
      setField<String>('Sub_Category_ID', value);
}
