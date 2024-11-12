import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'ApiResponse.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  int? code;
  String? message;
  T? data;

  ApiResponse();

  // 使用 json_serializable 自动生成的方法
  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$ApiResponseToJson(this, toJsonT);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
