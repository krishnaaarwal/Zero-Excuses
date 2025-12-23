import 'package:hive_ce/hive.dart';

// Create the class
// typeId and generateAdaptar
// run command
// init flutter
// register adaptar

part 'api_meta.g.dart';

@HiveType(typeId: 0)
class ApiMeta {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String code;

  @HiveField(2)
  final String name;

  const ApiMeta({required this.id, required this.code, required this.name});

  factory ApiMeta.fromJson(Map<String, dynamic> json) {
    return ApiMeta(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'code': code, 'name': name};
  }
}

//   factory ApiMeta.fromJson(Map<String, dynamic> json) {
//     return ApiMeta(
//       id: json['id'] as String?,
//       code: json['code'] as String?,
//       name: json['name'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'code': code,
//       'name': name,
//     };
//   }
// }
