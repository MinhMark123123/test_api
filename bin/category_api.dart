import 'dart:convert';

import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'data/data_response.dart';
import 'data/data_response_list.dart';

class CategoryApi {
  final List categoryList =
      json.decode(File('category_food.json').readAsStringSync());
  final headers = {"Content-Type": "application/json"};

  Router get router {
    final router = Router();
    //get category list food
    router.get("/", (Request request) {
      final dataResponse = DataListResponse(
        status: 200,
        data: List<Map<String, dynamic>>.from(categoryList),
      );
      return Response.ok(json.encode(dataResponse.toJson()));
    });
    //get category food by id
    router.get("/<id>", (Request request, String id) {
      final parsedId = int.tryParse(id);
      final category = categoryList.firstWhere(
          (element) => element["id"] == parsedId,
          orElse: () => null);
      if (category == null) {
        return Response.notFound(
          jsonEncode(
            DataResponse(
              status: 203,
              data: null,
              errorMessage: 'category not found',
            ),
          ),
        );
      }
      return Response.ok(jsonEncode(DataResponse(
        status: 200,
        data: category,
      )));
    });
    return router;
  }
}
