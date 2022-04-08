import 'dart:convert';

import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'data/data_response.dart';
import 'data/data_response_list.dart';

class FoodApi {
  final List foodList = json.decode(File('food_json.json').readAsStringSync());
  final headers = {"Content-Type": "application/json"};

  Router get router {
    final router = Router();
    //get food list
    router.get("/", (Request request) {
      final queryParams = request.requestedUri.queryParameters;
      print(queryParams);
      List listQuery = [];
      if (queryParams.isNotEmpty) {
        var categoryId = int.tryParse(queryParams["categoryId"]??"");
        if (categoryId != null) {
          print(categoryId);
          listQuery = foodList
              .toList()
              .where((element) => element['category_id'] == categoryId)
              .toList();
          print(listQuery.length);
        }
      }
      final dataResponse = DataListResponse(
        status: 200,
        data: List<Map<String, dynamic>>.from(
            (listQuery.isEmpty) ? foodList : listQuery),
      );
      return Response.ok(json.encode(dataResponse.toJson()));
    });
    //get food by id
    router.get("/<id>", (Request request, String id) {
      final parsedId = int.tryParse(id);
      final food = foodList.firstWhere((element) => element["id"] == parsedId,
          orElse: () => null);
      if (food == null) {
        return Response.notFound(jsonEncode(DataResponse(
            status: 203, data: null, errorMessage: "Food not found")));
      }
      return Response.ok(jsonEncode(DataResponse(status: 200, data: food)));
    });
    //get food with category
    // router.get("/?", (Request request,String categoryId) {
    //   final parsedId = int.tryParse(categoryId);
    //   final foodsFound = foodList.firstWhere((element) => element["category_id"] == parsedId,
    //       orElse: () => null);
    //   final dataResponse = DataListResponse(
    //     status: 200,
    //     data: List<Map<String, dynamic>>.from(foodsFound),
    //   );
    //   return Response.ok(json.encode(dataResponse.toJson()));
    // });
    //search
    // router.get("/food/<key>", (Request request, String key) {
    //   final parsedId = int.tryParse(id);
    //   final category = foodList.where(
    //       (element) => element["name"] == parsedId,
    //       orElse: () => null);
    //   if (category == null) {
    //     return Response.notFound(jsonEncode(DataResponse(status:203, data:[], errorMessage: "")));
    //   }
    //   return Response.ok(jsonEncode(DataResponse(status:200, data:category)));
    // });
    return router;
  }
}
