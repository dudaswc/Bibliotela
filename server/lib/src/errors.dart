/// Erro de API: vira uma resposta JSON no formato unico do contrato.
class ApiException implements Exception {
  const ApiException(this.status, this.code, this.message, {this.fields});

  factory ApiException.badRequest(String message) => ApiException(400, 'bad_request', message);

  factory ApiException.unauthorized() =>
      const ApiException(401, 'unauthorized', 'Missing, unknown or ended token');

  factory ApiException.notFound(String message) => ApiException(404, 'not_found', message);

  factory ApiException.validation(Map<String, String> fields, {String message = 'Invalid item'}) =>
      ApiException(422, 'validation', message, fields: fields);

  final int status;
  final String code;
  final String message;
  final Map<String, String>? fields;

  Map<String, Object?> toJson() => {
        'error': {
          'code': code,
          'message': message,
          if (fields != null) 'fields': fields,
        },
      };

  @override
  String toString() => 'ApiException($status, $code, $message)';
}
