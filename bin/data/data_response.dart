class DataResponse{
  int status;
  Map<String, dynamic>? data;
  String? errorMessage;

  DataResponse({required this.status, this.data, this.errorMessage});
  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data,
    'error_message': errorMessage,
  };
}