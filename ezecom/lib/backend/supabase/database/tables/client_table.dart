import '../database.dart';

class ClientTableTable extends SupabaseTable<ClientTableRow> {
  @override
  String get tableName => 'client_table';

  @override
  ClientTableRow createRow(Map<String, dynamic> data) => ClientTableRow(data);
}

class ClientTableRow extends SupabaseDataRow {
  ClientTableRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClientTableTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get companyName => getField<String>('Company_Name');
  set companyName(String? value) => setField<String>('Company_Name', value);

  String? get email => getField<String>('Email');
  set email(String? value) => setField<String>('Email', value);

  String? get role => getField<String>('Role');
  set role(String? value) => setField<String>('Role', value);

  String? get accountApproval => getField<String>('Account_Approval');
  set accountApproval(String? value) =>
      setField<String>('Account_Approval', value);

  dynamic? get cartList => getField<dynamic>('CartList');
  set cartList(dynamic? value) => setField<dynamic>('CartList', value);

  double? get phoneNumber => getField<double>('Phone_number');
  set phoneNumber(double? value) => setField<double>('Phone_number', value);

  String? get fCMToken => getField<String>('FCM_Token');
  set fCMToken(String? value) => setField<String>('FCM_Token', value);

  String? get oneSignalPlayerID => getField<String>('OneSignal_PlayerID');
  set oneSignalPlayerID(String? value) =>
      setField<String>('OneSignal_PlayerID', value);

  dynamic? get notification => getField<dynamic>('Notification');
  set notification(dynamic? value) => setField<dynamic>('Notification', value);

  String? get authID => getField<String>('Auth_ID');
  set authID(String? value) => setField<String>('Auth_ID', value);

  String? get rejectionReason => getField<String>('Rejection_Reason');
  set rejectionReason(String? value) =>
      setField<String>('Rejection_Reason', value);
}
