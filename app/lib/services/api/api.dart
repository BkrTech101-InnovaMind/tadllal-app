abstract class Api {
  // Future<LoginResponse> login({required signInSignUpRequest signInSignUpRequest});

  Future<List<dynamic>> fetchList({
    required List<dynamic> fieldNames,
    required String doctype,
    // required DoctypeDoc meta,
    required String orderBy,
    List<dynamic> filters,
    int? pageLength,
    int? offset,
  });
}
