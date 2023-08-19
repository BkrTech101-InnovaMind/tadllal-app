abstract class Api {
  // Future<LoginResponse> login({required sinInSinUpRequest sinInSinUpRequest});

  Future<List<dynamic>> fetchList({
    required List<dynamic> fieldnames,
    required String doctype,
    // required DoctypeDoc meta,
    required String orderBy,
    List<dynamic> filters,
    int? pageLength,
    int? offset,
  });
}
