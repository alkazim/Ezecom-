// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DynamicfieldsStruct extends BaseStruct {
  DynamicfieldsStruct({
    bool? feauture,
    bool? id,
    bool? value,
  })  : _feauture = feauture,
        _id = id,
        _value = value;

  // "feauture" field.
  bool? _feauture;
  bool get feauture => _feauture ?? false;
  set feauture(bool? val) => _feauture = val;

  bool hasFeauture() => _feauture != null;

  // "id" field.
  bool? _id;
  bool get id => _id ?? false;
  set id(bool? val) => _id = val;

  bool hasId() => _id != null;

  // "value" field.
  bool? _value;
  bool get value => _value ?? false;
  set value(bool? val) => _value = val;

  bool hasValue() => _value != null;

  static DynamicfieldsStruct fromMap(Map<String, dynamic> data) =>
      DynamicfieldsStruct(
        feauture: data['feauture'] as bool?,
        id: data['id'] as bool?,
        value: data['value'] as bool?,
      );

  static DynamicfieldsStruct? maybeFromMap(dynamic data) => data is Map
      ? DynamicfieldsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'feauture': _feauture,
        'id': _id,
        'value': _value,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'feauture': serializeParam(
          _feauture,
          ParamType.bool,
        ),
        'id': serializeParam(
          _id,
          ParamType.bool,
        ),
        'value': serializeParam(
          _value,
          ParamType.bool,
        ),
      }.withoutNulls;

  static DynamicfieldsStruct fromSerializableMap(Map<String, dynamic> data) =>
      DynamicfieldsStruct(
        feauture: deserializeParam(
          data['feauture'],
          ParamType.bool,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.bool,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'DynamicfieldsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DynamicfieldsStruct &&
        feauture == other.feauture &&
        id == other.id &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([feauture, id, value]);
}

DynamicfieldsStruct createDynamicfieldsStruct({
  bool? feauture,
  bool? id,
  bool? value,
}) =>
    DynamicfieldsStruct(
      feauture: feauture,
      id: id,
      value: value,
    );
