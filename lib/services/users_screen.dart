import '../core/network/dio_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/user.dart';

class UserApiService {
  final DioClient _dioClient = DioClient();

  Future<List<User>> getUsers() async {
    final response = await _dioClient.dio.get(ApiEndpoints.users);

    final List data = response.data;
    return data.map((e) => User.fromJson(e)).toList();
  }
}
