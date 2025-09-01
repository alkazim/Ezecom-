// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProductStatusStruct extends BaseStruct {
  ProductStatusStruct({
    bool? topDeals,
    bool? featuredOffer,
    bool? newArrival,
  })  : _topDeals = topDeals,
        _featuredOffer = featuredOffer,
        _newArrival = newArrival;

  // "TopDeals" field.
  bool? _topDeals;
  bool get topDeals => _topDeals ?? false;
  set topDeals(bool? val) => _topDeals = val;

  bool hasTopDeals() => _topDeals != null;

  // "FeaturedOffer" field.
  bool? _featuredOffer;
  bool get featuredOffer => _featuredOffer ?? false;
  set featuredOffer(bool? val) => _featuredOffer = val;

  bool hasFeaturedOffer() => _featuredOffer != null;

  // "NewArrival" field.
  bool? _newArrival;
  bool get newArrival => _newArrival ?? false;
  set newArrival(bool? val) => _newArrival = val;

  bool hasNewArrival() => _newArrival != null;

  static ProductStatusStruct fromMap(Map<String, dynamic> data) =>
      ProductStatusStruct(
        topDeals: data['TopDeals'] as bool?,
        featuredOffer: data['FeaturedOffer'] as bool?,
        newArrival: data['NewArrival'] as bool?,
      );

  static ProductStatusStruct? maybeFromMap(dynamic data) => data is Map
      ? ProductStatusStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'TopDeals': _topDeals,
        'FeaturedOffer': _featuredOffer,
        'NewArrival': _newArrival,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'TopDeals': serializeParam(
          _topDeals,
          ParamType.bool,
        ),
        'FeaturedOffer': serializeParam(
          _featuredOffer,
          ParamType.bool,
        ),
        'NewArrival': serializeParam(
          _newArrival,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ProductStatusStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProductStatusStruct(
        topDeals: deserializeParam(
          data['TopDeals'],
          ParamType.bool,
          false,
        ),
        featuredOffer: deserializeParam(
          data['FeaturedOffer'],
          ParamType.bool,
          false,
        ),
        newArrival: deserializeParam(
          data['NewArrival'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ProductStatusStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProductStatusStruct &&
        topDeals == other.topDeals &&
        featuredOffer == other.featuredOffer &&
        newArrival == other.newArrival;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([topDeals, featuredOffer, newArrival]);
}

ProductStatusStruct createProductStatusStruct({
  bool? topDeals,
  bool? featuredOffer,
  bool? newArrival,
}) =>
    ProductStatusStruct(
      topDeals: topDeals,
      featuredOffer: featuredOffer,
      newArrival: newArrival,
    );
