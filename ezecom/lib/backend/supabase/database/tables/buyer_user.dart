import '../database.dart';

class BuyerUserTable extends SupabaseTable<BuyerUserRow> {
  @override
  String get tableName => 'Buyer_User';

  @override
  BuyerUserRow createRow(Map<String, dynamic> data) => BuyerUserRow(data);
}

class BuyerUserRow extends SupabaseDataRow {
  BuyerUserRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BuyerUserTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get email => getField<String>('Email');
  set email(String? value) => setField<String>('Email', value);

  String? get contactPersonName => getField<String>('Contact_Person_Name');
  set contactPersonName(String? value) =>
      setField<String>('Contact_Person_Name', value);

  String? get contactNumber => getField<String>('Contact_Number');
  set contactNumber(String? value) => setField<String>('Contact_Number', value);

  String? get companyName => getField<String>('Company_Name');
  set companyName(String? value) => setField<String>('Company_Name', value);

  String? get companyAddress => getField<String>('Company_Address');
  set companyAddress(String? value) =>
      setField<String>('Company_Address', value);

  int? get taxRegistrationNumber => getField<int>('Tax_Registration_Number');
  set taxRegistrationNumber(int? value) =>
      setField<int>('Tax_Registration_Number', value);

  int? get ImportExportCertificateNumber =>
      getField<int>('Import_Export_Certificate_Number');
  set ImportExportCertificateNumber(int? value) =>
      setField<int>('Import_Export_Certificate_Number', value);

  String? get companyLogoOrTradeMark =>
      getField<String>('Company_Logo_or_Trade_Mark');
  set companyLogoOrTradeMark(String? value) =>
      setField<String>('Company_Logo_or_Trade_Mark', value);

  String? get companyCertificate => getField<String>('Company_Certificate');
  set companyCertificate(String? value) =>
      setField<String>('Company_Certificate', value);

  String? get taxCertificate => getField<String>('Tax_Certificate');
  set taxCertificate(String? value) =>
      setField<String>('Tax_Certificate', value);

  String? get tradeMarkRegistrationCertificatesOrLogoImage =>
      getField<String>('Trade_Mark_Registration_Certificates_or_Logo_Image');
  set tradeMarkRegistrationCertificatesOrLogoImage(String? value) =>
      setField<String>(
          'Trade_Mark_Registration_Certificates_or_Logo_Image', value);

  String? get ImportExportCertificatenumber =>
      getField<String>('Import_Export_Certificate_number');
  set ImportExportCertificatenumber(String? value) =>
      setField<String>('Import_Export_Certificate_number', value);

  String? get tempBanner => getField<String>('TempBanner');
  set tempBanner(String? value) => setField<String>('TempBanner', value);

  String? get companyRegistrationNumber =>
      getField<String>('CompanyRegistrationNumber');
  set companyRegistrationNumber(String? value) =>
      setField<String>('CompanyRegistrationNumber', value);

  String? get authID => getField<String>('Auth_ID');
  set authID(String? value) => setField<String>('Auth_ID', value);
}
