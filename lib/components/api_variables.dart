class ApiVariables{
  String _username;
  String _password;
  String _clientId;
  String _secretId;
  String _refreshToken;

  ApiVariables({
    required String username,
    required String password,
    required String clientId,
    required String secretId,
    required String refreshToken,
  })  : _username = username,
        _password = password,
        _clientId = clientId,
        _secretId = secretId,
        _refreshToken = refreshToken;

  String get username => _username;
  String get password => _password;
  String get clientId => _clientId;
  String get secretId => _secretId;
  String get refreshToken => _refreshToken;
}
ApiVariables apiVariables = ApiVariables(
  username: 'your_username',
  password: 'your_password',
  clientId: 'your_client_id',
  secretId: 'your_secret_id',
  refreshToken: 'your_refresh_token',
);