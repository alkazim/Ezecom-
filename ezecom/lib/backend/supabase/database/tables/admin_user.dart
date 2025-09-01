import '../database.dart';

class AdminUserTable extends SupabaseTable<AdminUserRow> {
  @override
  String get tableName => 'Admin_User';

  @override
  AdminUserRow createRow(Map<String, dynamic> data) => AdminUserRow(data);
}

class AdminUserRow extends SupabaseDataRow {
  AdminUserRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AdminUserTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('Name');
  set name(String? value) => setField<String>('Name', value);

  String? get mailID => getField<String>('Mail ID');
  set mailID(String? value) => setField<String>('Mail ID', value);

  String? get authID => getField<String>('Auth_ID');
  set authID(String? value) => setField<String>('Auth_ID', value);
}
