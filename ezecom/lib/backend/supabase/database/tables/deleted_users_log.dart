import '../database.dart';

class DeletedUsersLogTable extends SupabaseTable<DeletedUsersLogRow> {
  @override
  String get tableName => 'deleted_users_log';

  @override
  DeletedUsersLogRow createRow(Map<String, dynamic> data) =>
      DeletedUsersLogRow(data);
}

class DeletedUsersLogRow extends SupabaseDataRow {
  DeletedUsersLogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeletedUsersLogTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get deletedAt => getField<DateTime>('deleted_at')!;
  set deletedAt(DateTime value) => setField<DateTime>('deleted_at', value);

  String? get companyName => getField<String>('Company_name');
  set companyName(String? value) => setField<String>('Company_name', value);

  String? get email => getField<String>('Email');
  set email(String? value) => setField<String>('Email', value);

  String? get reason => getField<String>('Reason');
  set reason(String? value) => setField<String>('Reason', value);

  bool? get deleteByAdmin => getField<bool>('Delete_By_admin');
  set deleteByAdmin(bool? value) => setField<bool>('Delete_By_admin', value);
}
