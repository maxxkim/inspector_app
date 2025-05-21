import 'dart:convert';

class UserRequest {
  UserRequest({
    required this.identifier,
    required this.password,
  });

  String identifier;
  String password;

  Map<String, String> get headers => {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$identifier:$password'))}',
      };
}
