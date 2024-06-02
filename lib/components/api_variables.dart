import 'dart:ffi';

class ApiVariables {
  // Khai báo các biến instance với dấu _ trước tên biến để chỉ ra rằng chúng là private
  String _username;
  String _password;
  String _clientId;
  String _secretId;
  String _refreshToken;
  bool _isLogin;

  // Constructor của lớp ApiVariables, yêu cầu các tham số bắt buộc
  ApiVariables({
    required String username,
    required String password,
    required String clientId,
    required String secretId,
    required String refreshToken,
    required bool isLogin,
  })  : _username = username,
        _password = password,
        _clientId = clientId,
        _secretId = secretId,
        _refreshToken = refreshToken,
        _isLogin = isLogin;

  // Các hàm getter để truy cập các biến instance
  String get username => _username;
  String get password => _password;
  String get clientId => _clientId;
  String get secretId => _secretId;
  String get refreshToken => _refreshToken;
  bool get isLogin => _isLogin;

  // Các hàm setter để cập nhật các biến instance
  set username(String value) {
    _username = value;
  }

  set password(String value) {
    _password = value;
  }

  set clientId(String value) {
    _clientId = value;
  }

  set secretId(String value) {
    _secretId = value;
  }

  set refreshToken(String value) {
    _refreshToken = value;
  }

  set isLogin(bool value) {
    _isLogin = value;
  }
}

// Tạo một instance của lớp ApiVariables với các giá trị mặc định
final apiVariables = ApiVariables(
  username: '',
  password: '',
  clientId: '',
  secretId: '',
  refreshToken: '',
  isLogin: false,
);