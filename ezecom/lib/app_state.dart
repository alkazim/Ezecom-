import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _dynamicadd = prefs
              .getStringList('ff_dynamicadd')
              ?.map((x) {
                try {
                  return DynamicfieldsStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _dynamicadd;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  int _B1 = 0;
  int get B1 => _B1;
  set B1(int value) {
    _B1 = value;
  }

  int _B2 = 0;
  int get B2 => _B2;
  set B2(int value) {
    _B2 = value;
  }

  int _B3 = 0;
  int get B3 => _B3;
  set B3(int value) {
    _B3 = value;
  }

  String _CompanyName = '';
  String get CompanyName => _CompanyName;
  set CompanyName(String value) {
    _CompanyName = value;
  }

  String _CompanyAddress = '';
  String get CompanyAddress => _CompanyAddress;
  set CompanyAddress(String value) {
    _CompanyAddress = value;
  }

  String _CompanyContactNumber = '';
  String get CompanyContactNumber => _CompanyContactNumber;
  set CompanyContactNumber(String value) {
    _CompanyContactNumber = value;
  }

  String _CompanyEmail = '';
  String get CompanyEmail => _CompanyEmail;
  set CompanyEmail(String value) {
    _CompanyEmail = value;
  }

  String _OwnerDirectorIDNumber = '';
  String get OwnerDirectorIDNumber => _OwnerDirectorIDNumber;
  set OwnerDirectorIDNumber(String value) {
    _OwnerDirectorIDNumber = value;
  }

  String _ContactPersonName = '';
  String get ContactPersonName => _ContactPersonName;
  set ContactPersonName(String value) {
    _ContactPersonName = value;
  }

  String _ContactPersonMobileNumber = '';
  String get ContactPersonMobileNumber => _ContactPersonMobileNumber;
  set ContactPersonMobileNumber(String value) {
    _ContactPersonMobileNumber = value;
  }

  String _ContactPersonEmail = '';
  String get ContactPersonEmail => _ContactPersonEmail;
  set ContactPersonEmail(String value) {
    _ContactPersonEmail = value;
  }

  String _CompanyRegistrationCertificatePDF = '';
  String get CompanyRegistrationCertificatePDF =>
      _CompanyRegistrationCertificatePDF;
  set CompanyRegistrationCertificatePDF(String value) {
    _CompanyRegistrationCertificatePDF = value;
  }

  String _TaxRegistrationCertificatePDF = '';
  String get TaxRegistrationCertificatePDF => _TaxRegistrationCertificatePDF;
  set TaxRegistrationCertificatePDF(String value) {
    _TaxRegistrationCertificatePDF = value;
  }

  String _OwnerDirectorIDCardPDF = '';
  String get OwnerDirectorIDCardPDF => _OwnerDirectorIDCardPDF;
  set OwnerDirectorIDCardPDF(String value) {
    _OwnerDirectorIDCardPDF = value;
  }

  String _FactoryCompanyimagePDF = '';
  String get FactoryCompanyimagePDF => _FactoryCompanyimagePDF;
  set FactoryCompanyimagePDF(String value) {
    _FactoryCompanyimagePDF = value;
  }

  String _ImportExportCertificatePDF = '';
  String get ImportExportCertificatePDF => _ImportExportCertificatePDF;
  set ImportExportCertificatePDF(String value) {
    _ImportExportCertificatePDF = value;
  }

  String _LogoRegistrationCertificatePDF = '';
  String get LogoRegistrationCertificatePDF => _LogoRegistrationCertificatePDF;
  set LogoRegistrationCertificatePDF(String value) {
    _LogoRegistrationCertificatePDF = value;
  }

  String _TrademarkorLogoImagePDF = '';
  String get TrademarkorLogoImagePDF => _TrademarkorLogoImagePDF;
  set TrademarkorLogoImagePDF(String value) {
    _TrademarkorLogoImagePDF = value;
  }

  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;
  set isAdmin(bool value) {
    _isAdmin = value;
  }

  String _bCompanyLogoorTradeMark = '';
  String get bCompanyLogoorTradeMark => _bCompanyLogoorTradeMark;
  set bCompanyLogoorTradeMark(String value) {
    _bCompanyLogoorTradeMark = value;
  }

  String _bCompanyCertificate = '';
  String get bCompanyCertificate => _bCompanyCertificate;
  set bCompanyCertificate(String value) {
    _bCompanyCertificate = value;
  }

  String _bTaxCertificate = '';
  String get bTaxCertificate => _bTaxCertificate;
  set bTaxCertificate(String value) {
    _bTaxCertificate = value;
  }

  String _bTradeMarkRegistrationCertificatesorLogoImage = '';
  String get bTradeMarkRegistrationCertificatesorLogoImage =>
      _bTradeMarkRegistrationCertificatesorLogoImage;
  set bTradeMarkRegistrationCertificatesorLogoImage(String value) {
    _bTradeMarkRegistrationCertificatesorLogoImage = value;
  }

  String _bImportExportCertificate = '';
  String get bImportExportCertificate => _bImportExportCertificate;
  set bImportExportCertificate(String value) {
    _bImportExportCertificate = value;
  }

  bool _tb1 = false;
  bool get tb1 => _tb1;
  set tb1(bool value) {
    _tb1 = value;
  }

  int _numforlist = 0;
  int get numforlist => _numforlist;
  set numforlist(int value) {
    _numforlist = value;
  }

  dynamic _fieldstate;
  dynamic get fieldstate => _fieldstate;
  set fieldstate(dynamic value) {
    _fieldstate = value;
  }

  List<int> _ContainerList = [0, 1];
  List<int> get ContainerList => _ContainerList;
  set ContainerList(List<int> value) {
    _ContainerList = value;
  }

  void addToContainerList(int value) {
    ContainerList.add(value);
  }

  void removeFromContainerList(int value) {
    ContainerList.remove(value);
  }

  void removeAtIndexFromContainerList(int index) {
    ContainerList.removeAt(index);
  }

  void updateContainerListAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    ContainerList[index] = updateFn(_ContainerList[index]);
  }

  void insertAtIndexInContainerList(int index, int value) {
    ContainerList.insert(index, value);
  }

  List<dynamic> _DataModel = [];
  List<dynamic> get DataModel => _DataModel;
  set DataModel(List<dynamic> value) {
    _DataModel = value;
  }

  void addToDataModel(dynamic value) {
    DataModel.add(value);
  }

  void removeFromDataModel(dynamic value) {
    DataModel.remove(value);
  }

  void removeAtIndexFromDataModel(int index) {
    DataModel.removeAt(index);
  }

  void updateDataModelAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    DataModel[index] = updateFn(_DataModel[index]);
  }

  void insertAtIndexInDataModel(int index, dynamic value) {
    DataModel.insert(index, value);
  }

  String _icon1A = 'False';
  String get icon1A => _icon1A;
  set icon1A(String value) {
    _icon1A = value;
  }

  List<String> _TextFieldList = [];
  List<String> get TextFieldList => _TextFieldList;
  set TextFieldList(List<String> value) {
    _TextFieldList = value;
  }

  void addToTextFieldList(String value) {
    TextFieldList.add(value);
  }

  void removeFromTextFieldList(String value) {
    TextFieldList.remove(value);
  }

  void removeAtIndexFromTextFieldList(int index) {
    TextFieldList.removeAt(index);
  }

  void updateTextFieldListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    TextFieldList[index] = updateFn(_TextFieldList[index]);
  }

  void insertAtIndexInTextFieldList(int index, String value) {
    TextFieldList.insert(index, value);
  }

  List<String> _TextFieldList1 = [];
  List<String> get TextFieldList1 => _TextFieldList1;
  set TextFieldList1(List<String> value) {
    _TextFieldList1 = value;
  }

  void addToTextFieldList1(String value) {
    TextFieldList1.add(value);
  }

  void removeFromTextFieldList1(String value) {
    TextFieldList1.remove(value);
  }

  void removeAtIndexFromTextFieldList1(int index) {
    TextFieldList1.removeAt(index);
  }

  void updateTextFieldList1AtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    TextFieldList1[index] = updateFn(_TextFieldList1[index]);
  }

  void insertAtIndexInTextFieldList1(int index, String value) {
    TextFieldList1.insert(index, value);
  }

  List<DynamicfieldsStruct> _dynamicadd = [
    DynamicfieldsStruct.fromSerializableMap(jsonDecode(
        '{\"feauture\":\"Hello World\",\"id\":\"Hello World\",\"value\":\"Hello World\"}'))
  ];
  List<DynamicfieldsStruct> get dynamicadd => _dynamicadd;
  set dynamicadd(List<DynamicfieldsStruct> value) {
    _dynamicadd = value;
    prefs.setStringList(
        'ff_dynamicadd', value.map((x) => x.serialize()).toList());
  }

  void addToDynamicadd(DynamicfieldsStruct value) {
    dynamicadd.add(value);
    prefs.setStringList(
        'ff_dynamicadd', _dynamicadd.map((x) => x.serialize()).toList());
  }

  void removeFromDynamicadd(DynamicfieldsStruct value) {
    dynamicadd.remove(value);
    prefs.setStringList(
        'ff_dynamicadd', _dynamicadd.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromDynamicadd(int index) {
    dynamicadd.removeAt(index);
    prefs.setStringList(
        'ff_dynamicadd', _dynamicadd.map((x) => x.serialize()).toList());
  }

  void updateDynamicaddAtIndex(
    int index,
    DynamicfieldsStruct Function(DynamicfieldsStruct) updateFn,
  ) {
    dynamicadd[index] = updateFn(_dynamicadd[index]);
    prefs.setStringList(
        'ff_dynamicadd', _dynamicadd.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInDynamicadd(int index, DynamicfieldsStruct value) {
    dynamicadd.insert(index, value);
    prefs.setStringList(
        'ff_dynamicadd', _dynamicadd.map((x) => x.serialize()).toList());
  }

  List<String> _ImageList1 = [];
  List<String> get ImageList1 => _ImageList1;
  set ImageList1(List<String> value) {
    _ImageList1 = value;
  }

  void addToImageList1(String value) {
    ImageList1.add(value);
  }

  void removeFromImageList1(String value) {
    ImageList1.remove(value);
  }

  void removeAtIndexFromImageList1(int index) {
    ImageList1.removeAt(index);
  }

  void updateImageList1AtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    ImageList1[index] = updateFn(_ImageList1[index]);
  }

  void insertAtIndexInImageList1(int index, String value) {
    ImageList1.insert(index, value);
  }

  String _CtgryNameSeller = '';
  String get CtgryNameSeller => _CtgryNameSeller;
  set CtgryNameSeller(String value) {
    _CtgryNameSeller = value;
  }

  int _CtgryIdSeller = 0;
  int get CtgryIdSeller => _CtgryIdSeller;
  set CtgryIdSeller(int value) {
    _CtgryIdSeller = value;
  }

  /// to control the border in plans page of tab and desktop view
  int _B4 = 0;
  int get B4 => _B4;
  set B4(int value) {
    _B4 = value;
  }

  /// to control the border in plans page of tab and desktop view
  int _B5 = 0;
  int get B5 => _B5;
  set B5(int value) {
    _B5 = value;
  }

  /// to control the border in plans page of tab and desktop view
  int _B6 = 0;
  int get B6 => _B6;
  set B6(int value) {
    _B6 = value;
  }

  /// to control the border color in plans page of tab and desktop view
  Color _B4C = Color(4294967295);
  Color get B4C => _B4C;
  set B4C(Color value) {
    _B4C = value;
  }

  /// to control the border color in plans page of tab and desktop view
  Color _B5C = Color(4294967295);
  Color get B5C => _B5C;
  set B5C(Color value) {
    _B5C = value;
  }

  /// to control the border color in plans page of tab and desktop view
  Color _B6C = Color(4294967295);
  Color get B6C => _B6C;
  set B6C(Color value) {
    _B6C = value;
  }

  /// variable for determing plan type for desktop
  String _Plantype = 'null';
  String get Plantype => _Plantype;
  set Plantype(String value) {
    _Plantype = value;
  }

  int _indexvalue = 0;
  int get indexvalue => _indexvalue;
  set indexvalue(int value) {
    _indexvalue = value;
  }

  /// list to store images of producs for mobile view
  List<String> _imageList2 = [];
  List<String> get imageList2 => _imageList2;
  set imageList2(List<String> value) {
    _imageList2 = value;
  }

  void addToImageList2(String value) {
    imageList2.add(value);
  }

  void removeFromImageList2(String value) {
    imageList2.remove(value);
  }

  void removeAtIndexFromImageList2(int index) {
    imageList2.removeAt(index);
  }

  void updateImageList2AtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    imageList2[index] = updateFn(_imageList2[index]);
  }

  void insertAtIndexInImageList2(int index, String value) {
    imageList2.insert(index, value);
  }

  /// snack for product added successfully
  bool _showsnackbar1 = false;
  bool get showsnackbar1 => _showsnackbar1;
  set showsnackbar1(bool value) {
    _showsnackbar1 = value;
  }

  /// Failed to add product
  bool _showsnackbar2 = false;
  bool get showsnackbar2 => _showsnackbar2;
  set showsnackbar2(bool value) {
    _showsnackbar2 = value;
  }

  String _AddedBy = '';
  String get AddedBy => _AddedBy;
  set AddedBy(String value) {
    _AddedBy = value;
  }

  dynamic _ProductStatuss = jsonDecode(
      '{\"TopDeals\":false,\"NewArrival\":false,\"FeaturedOffer\":false}');
  dynamic get ProductStatuss => _ProductStatuss;
  set ProductStatuss(dynamic value) {
    _ProductStatuss = value;
  }

  ProductStatusStruct _TestVariable = ProductStatusStruct();
  ProductStatusStruct get TestVariable => _TestVariable;
  set TestVariable(ProductStatusStruct value) {
    _TestVariable = value;
  }

  void updateTestVariableStruct(Function(ProductStatusStruct) updateFn) {
    updateFn(_TestVariable);
  }

  /// json for finding the topdelas product from products_table
  ProductStatusStruct _topdealJSON = ProductStatusStruct.fromSerializableMap(
      jsonDecode('{\"TopDeals\":\"true\"}'));
  ProductStatusStruct get topdealJSON => _topdealJSON;
  set topdealJSON(ProductStatusStruct value) {
    _topdealJSON = value;
  }

  void updateTopdealJSONStruct(Function(ProductStatusStruct) updateFn) {
    updateFn(_topdealJSON);
  }

  /// this list contains the list of product ID which have topdelas field set to
  /// true in supabase database
  List<int> _topdealsProductID = [];
  List<int> get topdealsProductID => _topdealsProductID;
  set topdealsProductID(List<int> value) {
    _topdealsProductID = value;
  }

  void addToTopdealsProductID(int value) {
    topdealsProductID.add(value);
  }

  void removeFromTopdealsProductID(int value) {
    topdealsProductID.remove(value);
  }

  void removeAtIndexFromTopdealsProductID(int index) {
    topdealsProductID.removeAt(index);
  }

  void updateTopdealsProductIDAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    topdealsProductID[index] = updateFn(_topdealsProductID[index]);
  }

  void insertAtIndexInTopdealsProductID(int index, int value) {
    topdealsProductID.insert(index, value);
  }

  dynamic _test1 = jsonDecode(
      '{\"TopDeals\":true,\"NewArrival\":false,\"FeaturedOffer\":false}');
  dynamic get test1 => _test1;
  set test1(dynamic value) {
    _test1 = value;
  }

  List<String> _test2 = [];
  List<String> get test2 => _test2;
  set test2(List<String> value) {
    _test2 = value;
  }

  void addToTest2(String value) {
    test2.add(value);
  }

  void removeFromTest2(String value) {
    test2.remove(value);
  }

  void removeAtIndexFromTest2(int index) {
    test2.removeAt(index);
  }

  void updateTest2AtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    test2[index] = updateFn(_test2[index]);
  }

  void insertAtIndexInTest2(int index, String value) {
    test2.insert(index, value);
  }

  List<int> _TDpids = [];
  List<int> get TDpids => _TDpids;
  set TDpids(List<int> value) {
    _TDpids = value;
  }

  void addToTDpids(int value) {
    TDpids.add(value);
  }

  void removeFromTDpids(int value) {
    TDpids.remove(value);
  }

  void removeAtIndexFromTDpids(int index) {
    TDpids.removeAt(index);
  }

  void updateTDpidsAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    TDpids[index] = updateFn(_TDpids[index]);
  }

  void insertAtIndexInTDpids(int index, int value) {
    TDpids.insert(index, value);
  }

  List<int> _FOpids = [];
  List<int> get FOpids => _FOpids;
  set FOpids(List<int> value) {
    _FOpids = value;
  }

  void addToFOpids(int value) {
    FOpids.add(value);
  }

  void removeFromFOpids(int value) {
    FOpids.remove(value);
  }

  void removeAtIndexFromFOpids(int index) {
    FOpids.removeAt(index);
  }

  void updateFOpidsAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    FOpids[index] = updateFn(_FOpids[index]);
  }

  void insertAtIndexInFOpids(int index, int value) {
    FOpids.insert(index, value);
  }

  List<int> _NApids = [];
  List<int> get NApids => _NApids;
  set NApids(List<int> value) {
    _NApids = value;
  }

  void addToNApids(int value) {
    NApids.add(value);
  }

  void removeFromNApids(int value) {
    NApids.remove(value);
  }

  void removeAtIndexFromNApids(int index) {
    NApids.removeAt(index);
  }

  void updateNApidsAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    NApids[index] = updateFn(_NApids[index]);
  }

  void insertAtIndexInNApids(int index, int value) {
    NApids.insert(index, value);
  }

  double _planAmount = 0.0;
  double get planAmount => _planAmount;
  set planAmount(double value) {
    _planAmount = value;
  }

  /// snackbar for password do not match
  bool _snackbar3 = false;
  bool get snackbar3 => _snackbar3;
  set snackbar3(bool value) {
    _snackbar3 = value;
  }

  /// for order placed successsfully
  bool _snackbar4 = false;
  bool get snackbar4 => _snackbar4;
  set snackbar4(bool value) {
    _snackbar4 = value;
  }

  /// for please select quantity
  bool _snackbar5 = false;
  bool get snackbar5 => _snackbar5;
  set snackbar5(bool value) {
    _snackbar5 = value;
  }

  List<String> _AddCartList = [];
  List<String> get AddCartList => _AddCartList;
  set AddCartList(List<String> value) {
    _AddCartList = value;
  }

  void addToAddCartList(String value) {
    AddCartList.add(value);
  }

  void removeFromAddCartList(String value) {
    AddCartList.remove(value);
  }

  void removeAtIndexFromAddCartList(int index) {
    AddCartList.removeAt(index);
  }

  void updateAddCartListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    AddCartList[index] = updateFn(_AddCartList[index]);
  }

  void insertAtIndexInAddCartList(int index, String value) {
    AddCartList.insert(index, value);
  }

  String _CompanyNameInApp = '';
  String get CompanyNameInApp => _CompanyNameInApp;
  set CompanyNameInApp(String value) {
    _CompanyNameInApp = value;
  }

  /// price for payment In-App
  ///
  int _priceVariable = 0;
  int get priceVariable => _priceVariable;
  set priceVariable(int value) {
    _priceVariable = value;
  }

  String _TrademarkRegistrationCertificate = '';
  String get TrademarkRegistrationCertificate =>
      _TrademarkRegistrationCertificate;
  set TrademarkRegistrationCertificate(String value) {
    _TrademarkRegistrationCertificate = value;
  }

  String _ImportExportCertificate = '';
  String get ImportExportCertificate => _ImportExportCertificate;
  set ImportExportCertificate(String value) {
    _ImportExportCertificate = value;
  }

  /// variable to get the company name for the seller dashboard pages
  String _CompanyName1 = '';
  String get CompanyName1 => _CompanyName1;
  set CompanyName1(String value) {
    _CompanyName1 = value;
  }

  bool _skip = false;
  bool get skip => _skip;
  set skip(bool value) {
    _skip = value;
  }

  List<int> _cartItems = [];
  List<int> get cartItems => _cartItems;
  set cartItems(List<int> value) {
    _cartItems = value;
  }

  void addToCartItems(int value) {
    cartItems.add(value);
  }

  void removeFromCartItems(int value) {
    cartItems.remove(value);
  }

  void removeAtIndexFromCartItems(int index) {
    cartItems.removeAt(index);
  }

  void updateCartItemsAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    cartItems[index] = updateFn(_cartItems[index]);
  }

  void insertAtIndexInCartItems(int index, int value) {
    cartItems.insert(index, value);
  }

  bool _inCart = false;
  bool get inCart => _inCart;
  set inCart(bool value) {
    _inCart = value;
  }

  List<int> _cartListItems = [];
  List<int> get cartListItems => _cartListItems;
  set cartListItems(List<int> value) {
    _cartListItems = value;
  }

  void addToCartListItems(int value) {
    cartListItems.add(value);
  }

  void removeFromCartListItems(int value) {
    cartListItems.remove(value);
  }

  void removeAtIndexFromCartListItems(int index) {
    cartListItems.removeAt(index);
  }

  void updateCartListItemsAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    cartListItems[index] = updateFn(_cartListItems[index]);
  }

  void insertAtIndexInCartListItems(int index, int value) {
    cartListItems.insert(index, value);
  }

  List<String> _categoryList = [];
  List<String> get categoryList => _categoryList;
  set categoryList(List<String> value) {
    _categoryList = value;
  }

  void addToCategoryList(String value) {
    categoryList.add(value);
  }

  void removeFromCategoryList(String value) {
    categoryList.remove(value);
  }

  void removeAtIndexFromCategoryList(int index) {
    categoryList.removeAt(index);
  }

  void updateCategoryListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    categoryList[index] = updateFn(_categoryList[index]);
  }

  void insertAtIndexInCategoryList(int index, String value) {
    categoryList.insert(index, value);
  }

  List<String> _SubCtaegoryList = ['No Category Selected'];
  List<String> get SubCtaegoryList => _SubCtaegoryList;
  set SubCtaegoryList(List<String> value) {
    _SubCtaegoryList = value;
  }

  void addToSubCtaegoryList(String value) {
    SubCtaegoryList.add(value);
  }

  void removeFromSubCtaegoryList(String value) {
    SubCtaegoryList.remove(value);
  }

  void removeAtIndexFromSubCtaegoryList(int index) {
    SubCtaegoryList.removeAt(index);
  }

  void updateSubCtaegoryListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    SubCtaegoryList[index] = updateFn(_SubCtaegoryList[index]);
  }

  void insertAtIndexInSubCtaegoryList(int index, String value) {
    SubCtaegoryList.insert(index, value);
  }

  /// for Already added to cart pop up
  bool _snackbar6 = false;
  bool get snackbar6 => _snackbar6;
  set snackbar6(bool value) {
    _snackbar6 = value;
  }

  List<CartListStruct> _CartItemList = [];
  List<CartListStruct> get CartItemList => _CartItemList;
  set CartItemList(List<CartListStruct> value) {
    _CartItemList = value;
  }

  void addToCartItemList(CartListStruct value) {
    CartItemList.add(value);
  }

  void removeFromCartItemList(CartListStruct value) {
    CartItemList.remove(value);
  }

  void removeAtIndexFromCartItemList(int index) {
    CartItemList.removeAt(index);
  }

  void updateCartItemListAtIndex(
    int index,
    CartListStruct Function(CartListStruct) updateFn,
  ) {
    CartItemList[index] = updateFn(_CartItemList[index]);
  }

  void insertAtIndexInCartItemList(int index, CartListStruct value) {
    CartItemList.insert(index, value);
  }

  int _orderCount = 0;
  int get orderCount => _orderCount;
  set orderCount(int value) {
    _orderCount = value;
  }

  /// image list for product detauils page
  List<String> _imageListPD = [];
  List<String> get imageListPD => _imageListPD;
  set imageListPD(List<String> value) {
    _imageListPD = value;
  }

  void addToImageListPD(String value) {
    imageListPD.add(value);
  }

  void removeFromImageListPD(String value) {
    imageListPD.remove(value);
  }

  void removeAtIndexFromImageListPD(int index) {
    imageListPD.removeAt(index);
  }

  void updateImageListPDAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    imageListPD[index] = updateFn(_imageListPD[index]);
  }

  void insertAtIndexInImageListPD(int index, String value) {
    imageListPD.insert(index, value);
  }

  /// for error occured snackbar
  bool _snackbar7 = false;
  bool get snackbar7 => _snackbar7;
  set snackbar7(bool value) {
    _snackbar7 = value;
  }

  /// For product detailing variable
  String _ImagewURL = '';
  String get ImagewURL => _ImagewURL;
  set ImagewURL(String value) {
    _ImagewURL = value;
  }

  int _index1 = 0;
  int get index1 => _index1;
  set index1(int value) {
    _index1 = value;
  }

  String _Role = 'null';
  String get Role => _Role;
  set Role(String value) {
    _Role = value;
  }

  bool _AddProductLimit = false;
  bool get AddProductLimit => _AddProductLimit;
  set AddProductLimit(bool value) {
    _AddProductLimit = value;
  }

  bool _snackbar8 = false;
  bool get snackbar8 => _snackbar8;
  set snackbar8(bool value) {
    _snackbar8 = value;
  }

  List<String> _selectedImagesList = [];
  List<String> get selectedImagesList => _selectedImagesList;
  set selectedImagesList(List<String> value) {
    _selectedImagesList = value;
  }

  void addToSelectedImagesList(String value) {
    selectedImagesList.add(value);
  }

  void removeFromSelectedImagesList(String value) {
    selectedImagesList.remove(value);
  }

  void removeAtIndexFromSelectedImagesList(int index) {
    selectedImagesList.removeAt(index);
  }

  void updateSelectedImagesListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedImagesList[index] = updateFn(_selectedImagesList[index]);
  }

  void insertAtIndexInSelectedImagesList(int index, String value) {
    selectedImagesList.insert(index, value);
  }

  int _IndexValue = 0;
  int get IndexValue => _IndexValue;
  set IndexValue(int value) {
    _IndexValue = value;
  }

  double _GSTPrice = 0.0;
  double get GSTPrice => _GSTPrice;
  set GSTPrice(double value) {
    _GSTPrice = value;
  }

  String _FactoryCompanyimage = '';
  String get FactoryCompanyimage => _FactoryCompanyimage;
  set FactoryCompanyimage(String value) {
    _FactoryCompanyimage = value;
  }

  String _TrademarkorLogoImage = '';
  String get TrademarkorLogoImage => _TrademarkorLogoImage;
  set TrademarkorLogoImage(String value) {
    _TrademarkorLogoImage = value;
  }

  String _CompanyLogoorTradeMarkPDF = '';
  String get CompanyLogoorTradeMarkPDF => _CompanyLogoorTradeMarkPDF;
  set CompanyLogoorTradeMarkPDF(String value) {
    _CompanyLogoorTradeMarkPDF = value;
  }

  String _CompanyCertificatePDF = '';
  String get CompanyCertificatePDF => _CompanyCertificatePDF;
  set CompanyCertificatePDF(String value) {
    _CompanyCertificatePDF = value;
  }

  String _TaxCertificatePDF = '';
  String get TaxCertificatePDF => _TaxCertificatePDF;
  set TaxCertificatePDF(String value) {
    _TaxCertificatePDF = value;
  }

  String _TradeMarkRegistrationCertificatesorLogoImagePDF = '';
  String get TradeMarkRegistrationCertificatesorLogoImagePDF =>
      _TradeMarkRegistrationCertificatesorLogoImagePDF;
  set TradeMarkRegistrationCertificatesorLogoImagePDF(String value) {
    _TradeMarkRegistrationCertificatesorLogoImagePDF = value;
  }

  String _ImportExportCertificatenumberPDF = '';
  String get ImportExportCertificatenumberPDF =>
      _ImportExportCertificatenumberPDF;
  set ImportExportCertificatenumberPDF(String value) {
    _ImportExportCertificatenumberPDF = value;
  }

  String _clientID = '';
  String get clientID => _clientID;
  set clientID(String value) {
    _clientID = value;
  }

  String _secretKey = '';
  String get secretKey => _secretKey;
  set secretKey(String value) {
    _secretKey = value;
  }

  bool _sandboxMode = false;
  bool get sandboxMode => _sandboxMode;
  set sandboxMode(bool value) {
    _sandboxMode = value;
  }

  String _newRole = '';
  String get newRole => _newRole;
  set newRole(String value) {
    _newRole = value;
  }

  List<String> _BannerProductList = [];
  List<String> get BannerProductList => _BannerProductList;
  set BannerProductList(List<String> value) {
    _BannerProductList = value;
  }

  void addToBannerProductList(String value) {
    BannerProductList.add(value);
  }

  void removeFromBannerProductList(String value) {
    BannerProductList.remove(value);
  }

  void removeAtIndexFromBannerProductList(int index) {
    BannerProductList.removeAt(index);
  }

  void updateBannerProductListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    BannerProductList[index] = updateFn(_BannerProductList[index]);
  }

  void insertAtIndexInBannerProductList(int index, String value) {
    BannerProductList.insert(index, value);
  }

  String _PaymentMethod = '';
  String get PaymentMethod => _PaymentMethod;
  set PaymentMethod(String value) {
    _PaymentMethod = value;
  }

  double _border1 = 0.0;
  double get border1 => _border1;
  set border1(double value) {
    _border1 = value;
  }

  double _border2 = 0.0;
  double get border2 => _border2;
  set border2(double value) {
    _border2 = value;
  }

  bool _cartVisible = false;
  bool get cartVisible => _cartVisible;
  set cartVisible(bool value) {
    _cartVisible = value;
  }

  String _MobileDimension = '';
  String get MobileDimension => _MobileDimension;
  set MobileDimension(String value) {
    _MobileDimension = value;
  }

  String _DesktopDimension = '';
  String get DesktopDimension => _DesktopDimension;
  set DesktopDimension(String value) {
    _DesktopDimension = value;
  }

  List<String> _ApprovedProductList = [];
  List<String> get ApprovedProductList => _ApprovedProductList;
  set ApprovedProductList(List<String> value) {
    _ApprovedProductList = value;
  }

  void addToApprovedProductList(String value) {
    ApprovedProductList.add(value);
  }

  void removeFromApprovedProductList(String value) {
    ApprovedProductList.remove(value);
  }

  void removeAtIndexFromApprovedProductList(int index) {
    ApprovedProductList.removeAt(index);
  }

  void updateApprovedProductListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    ApprovedProductList[index] = updateFn(_ApprovedProductList[index]);
  }

  void insertAtIndexInApprovedProductList(int index, String value) {
    ApprovedProductList.insert(index, value);
  }

  String _DesktopBannerImage = '';
  String get DesktopBannerImage => _DesktopBannerImage;
  set DesktopBannerImage(String value) {
    _DesktopBannerImage = value;
  }

  bool _Iscarton = false;
  bool get Iscarton => _Iscarton;
  set Iscarton(bool value) {
    _Iscarton = value;
  }

  bool _AmountVisible = false;
  bool get AmountVisible => _AmountVisible;
  set AmountVisible(bool value) {
    _AmountVisible = value;
  }

  String _DeleteReason = '';
  String get DeleteReason => _DeleteReason;
  set DeleteReason(String value) {
    _DeleteReason = value;
  }

  bool _cartvisible2 = false;
  bool get cartvisible2 => _cartvisible2;
  set cartvisible2(bool value) {
    _cartvisible2 = value;
  }

  bool _isCartMain = false;
  bool get isCartMain => _isCartMain;
  set isCartMain(bool value) {
    _isCartMain = value;
  }

  bool _show = false;
  bool get show => _show;
  set show(bool value) {
    _show = value;
  }

  bool _testerValue = false;
  bool get testerValue => _testerValue;
  set testerValue(bool value) {
    _testerValue = value;
  }

  String _PaymentMethodPlan = '';
  String get PaymentMethodPlan => _PaymentMethodPlan;
  set PaymentMethodPlan(String value) {
    _PaymentMethodPlan = value;
  }

  String _NewMobileBannerImage = '';
  String get NewMobileBannerImage => _NewMobileBannerImage;
  set NewMobileBannerImage(String value) {
    _NewMobileBannerImage = value;
  }

  String _NewMobileDimension = '';
  String get NewMobileDimension => _NewMobileDimension;
  set NewMobileDimension(String value) {
    _NewMobileDimension = value;
  }

  bool _mobileChanged = false;
  bool get mobileChanged => _mobileChanged;
  set mobileChanged(bool value) {
    _mobileChanged = value;
  }

  String _MobileBannerImage = '';
  String get MobileBannerImage => _MobileBannerImage;
  set MobileBannerImage(String value) {
    _MobileBannerImage = value;
  }

  bool _desktopChanged = false;
  bool get desktopChanged => _desktopChanged;
  set desktopChanged(bool value) {
    _desktopChanged = value;
  }

  /// variable used for setting navigation to seller dashboard or homepage
  bool _initialState = false;
  bool get initialState => _initialState;
  set initialState(bool value) {
    _initialState = value;
  }

  String _PhoneLink = '';
  String get PhoneLink => _PhoneLink;
  set PhoneLink(String value) {
    _PhoneLink = value;
  }

  String _DesktopLink = '';
  String get DesktopLink => _DesktopLink;
  set DesktopLink(String value) {
    _DesktopLink = value;
  }

  List<int> _variation1 = [];
  List<int> get variation1 => _variation1;
  set variation1(List<int> value) {
    _variation1 = value;
  }

  void addToVariation1(int value) {
    variation1.add(value);
  }

  void removeFromVariation1(int value) {
    variation1.remove(value);
  }

  void removeAtIndexFromVariation1(int index) {
    variation1.removeAt(index);
  }

  void updateVariation1AtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    variation1[index] = updateFn(_variation1[index]);
  }

  void insertAtIndexInVariation1(int index, int value) {
    variation1.insert(index, value);
  }

  int _cartContainerHeight = 200;
  int get cartContainerHeight => _cartContainerHeight;
  set cartContainerHeight(int value) {
    _cartContainerHeight = value;
  }

  bool _NotificationState = false;
  bool get NotificationState => _NotificationState;
  set NotificationState(bool value) {
    _NotificationState = value;
  }

  bool _CompanyLogoorTradeMark = false;
  bool get CompanyLogoorTradeMark => _CompanyLogoorTradeMark;
  set CompanyLogoorTradeMark(bool value) {
    _CompanyLogoorTradeMark = value;
  }

  bool _CompanyCertificate = false;
  bool get CompanyCertificate => _CompanyCertificate;
  set CompanyCertificate(bool value) {
    _CompanyCertificate = value;
  }

  bool _TaxCertificate = false;
  bool get TaxCertificate => _TaxCertificate;
  set TaxCertificate(bool value) {
    _TaxCertificate = value;
  }

  bool _TradeMarkRegistrationCertificatesorLogoImage = false;
  bool get TradeMarkRegistrationCertificatesorLogoImage =>
      _TradeMarkRegistrationCertificatesorLogoImage;
  set TradeMarkRegistrationCertificatesorLogoImage(bool value) {
    _TradeMarkRegistrationCertificatesorLogoImage = value;
  }

  bool _ImportExportCertificatenumber = false;
  bool get ImportExportCertificatenumber => _ImportExportCertificatenumber;
  set ImportExportCertificatenumber(bool value) {
    _ImportExportCertificatenumber = value;
  }

  String _linkurl = '';
  String get linkurl => _linkurl;
  set linkurl(String value) {
    _linkurl = value;
  }

  bool _CompanyRegistrationCertificate = false;
  bool get CompanyRegistrationCertificate => _CompanyRegistrationCertificate;
  set CompanyRegistrationCertificate(bool value) {
    _CompanyRegistrationCertificate = value;
  }

  bool _TaxRegistrationCertificate = false;
  bool get TaxRegistrationCertificate => _TaxRegistrationCertificate;
  set TaxRegistrationCertificate(bool value) {
    _TaxRegistrationCertificate = value;
  }

  bool _OwnerDirectorIDCard = false;
  bool get OwnerDirectorIDCard => _OwnerDirectorIDCard;
  set OwnerDirectorIDCard(bool value) {
    _OwnerDirectorIDCard = value;
  }

  bool _FactoryCompanyimages = false;
  bool get FactoryCompanyimages => _FactoryCompanyimages;
  set FactoryCompanyimages(bool value) {
    _FactoryCompanyimages = value;
  }

  bool _ImportExportCertificates = false;
  bool get ImportExportCertificates => _ImportExportCertificates;
  set ImportExportCertificates(bool value) {
    _ImportExportCertificates = value;
  }

  bool _LogoRegistrationCertificate = false;
  bool get LogoRegistrationCertificate => _LogoRegistrationCertificate;
  set LogoRegistrationCertificate(bool value) {
    _LogoRegistrationCertificate = value;
  }

  bool _TrademarkorLogoImages = false;
  bool get TrademarkorLogoImages => _TrademarkorLogoImages;
  set TrademarkorLogoImages(bool value) {
    _TrademarkorLogoImages = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

Color? _colorFromIntValue(int? val) {
  if (val == null) {
    return null;
  }
  return Color(val);
}
