// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      link: json['link'] as String,
      imageLink: json['image_link'] as String,
      additionalImageLink: json['additional_image_link'] as String,
      availability: json['availability'] as String,
      listPrice: json['list_price'] as String,
      salePrice: json['sale_price'] as String,
      gtin: json['gtin'] as String,
      productType: json['product_type'] as String,
      brand: json['brand'] as String,
      condition: json['condition'] as String,
      rawColor: json['raw_color'] as String,
      color: json['color'] as String,
      gender: json['gender'] as String,
      sizeFormat: json['size_format'] as String,
      sizingSchema: json['sizing_schema'] as String,
      sizes: json['sizes'] as String,
      sizeType: json['size_type'] as String,
      itemGroupId: (json['item_group_id'] as num).toInt(),
      category: json['category'] as String,
      shipping: json['shipping'] as String,
      mpn: json['mpn'] as String,
      material: json['material'] as String,
      collection: json['collection'] as String,
      additionalImageLink2: json['additional_image_link_2'] as String,
      additionalImageLink3: json['additional_image_link_3'] as String,
      additionalImageLink4: json['additional_image_link_4'] as String,
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'link': instance.link,
      'image_link': instance.imageLink,
      'additional_image_link': instance.additionalImageLink,
      'availability': instance.availability,
      'list_price': instance.listPrice,
      'sale_price': instance.salePrice,
      'gtin': instance.gtin,
      'product_type': instance.productType,
      'brand': instance.brand,
      'condition': instance.condition,
      'raw_color': instance.rawColor,
      'color': instance.color,
      'gender': instance.gender,
      'size_format': instance.sizeFormat,
      'sizing_schema': instance.sizingSchema,
      'sizes': instance.sizes,
      'size_type': instance.sizeType,
      'item_group_id': instance.itemGroupId,
      'category': instance.category,
      'shipping': instance.shipping,
      'mpn': instance.mpn,
      'material': instance.material,
      'collection': instance.collection,
      'additional_image_link_2': instance.additionalImageLink2,
      'additional_image_link_3': instance.additionalImageLink3,
      'additional_image_link_4': instance.additionalImageLink4,
    };
