// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      postId: json['postId'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'postId': instance.postId,
      'id': instance.id,
      'name': instance.name,
      'body': instance.body,
    };
