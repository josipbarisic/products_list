// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    required String title,
    required String description,
    required String link,
    @JsonKey(name: 'image_link') required String imageLink,
    @JsonKey(name: 'additional_image_link') required String additionalImageLink,
    required String availability,
    @JsonKey(name: 'list_price') required String listPrice,
    @JsonKey(name: 'sale_price') required String salePrice,
    required String gtin,
    @JsonKey(name: 'product_type') required String productType,
    required String brand,
    required String condition,
    @JsonKey(name: 'raw_color') required String rawColor,
    required String color,
    required String gender,
    @JsonKey(name: 'size_format') required String sizeFormat,
    @JsonKey(name: 'sizing_schema') required String sizingSchema,
    required String sizes,
    @JsonKey(name: 'size_type') required String sizeType,
    @JsonKey(name: 'item_group_id') required int itemGroupId,
    required String category,
    required String shipping,
    required String mpn,
    required String material,
    required String collection,
    @JsonKey(name: 'additional_image_link_2') required String additionalImageLink2,
    @JsonKey(name: 'additional_image_link_3') required String additionalImageLink3,
    @JsonKey(name: 'additional_image_link_4') required String additionalImageLink4,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
/*
String _idFromJson(dynamic value) {
  if (value == null) return '';
  if (value is int) return value.toString();
  if (value is String) return value;
  return value.toString();
}

String _stringFromJson(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

double _priceFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed ?? 0.0;
  }
  if (value is num) return value.toDouble();
  return 0.0;
}

List<String> _imageLinksFromJson(dynamic value) {
  final result = <String>[];

  if (value == null) return result;

  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }

  return result;
}*/
