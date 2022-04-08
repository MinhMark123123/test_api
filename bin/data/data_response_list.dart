class DataListResponse{
  int status;
  List<Map<String, dynamic>>  data;
  String? errorMessage;


  DataListResponse({required this.status, required this.data, this.errorMessage});


  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data,
    'error_message': errorMessage,
  };
}