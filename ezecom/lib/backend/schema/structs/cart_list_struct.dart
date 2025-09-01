// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CartListStruct extends BaseStruct {
  CartListStruct({
    int? quantity,
    int? productid,
  })  : _quantity = quantity,
        _productid = productid;

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  set quantity(int? val) => _quantity = val;

  void incrementQuantity(int amount) => quantity = quantity + amount;

  bool hasQuantity() => _quantity != null;

  // "productid" field.
  int? _productid;
  int get productid => _productid ?? 0;
  set productid(int? val) => _productid = val;

  void incrementProductid(int amount) => productid = productid + amount;

  bool hasProductid() => _productid != null;

  static CartListStruct fromMap(Map<String, dynamic> data) => CartListStruct(
        quantity: castToType<int>(data['quantity']),
        productid: castToType<int>(data['productid']),
      );

  static CartListStruct? maybeFromMap(dynamic data) =>
      data is Map ? CartListStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'quantity': _quantity,
        'productid': _productid,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'quantity': serializeParam(
          _quantity,
          ParamType.int,
        ),
        'productid': serializeParam(
          _productid,
          ParamType.int,
        ),
      }.withoutNulls;

  static CartListStruct fromSerializableMap(Map<String, dynamic> data) =>
      CartListStruct(
        quantity: deserializeParam(
          data['quantity'],
          ParamType.int,
          false,
        ),
        productid: deserializeParam(
          data['productid'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'CartListStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CartListStruct &&
        quantity == other.quantity &&
        productid == other.productid;
  }

  @override
  int get hashCode => const ListEquality().hash([quantity, productid]);
}

CartListStruct createCartListStruct({
  int? quantity,
  int? productid,
}) =>
    CartListStruct(
      quantity: quantity,
      productid: productid,
    );
