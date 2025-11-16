import 'dart:convert';

import 'package:http/http.dart' as http;

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080/api',
);

class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? apiBaseUrl;

  final http.Client _client;
  final String _baseUrl;

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final q = <String, String>{};
    query?.forEach((key, value) {
      if (value == null) return;
      if (value is String && value.isEmpty) return;
      q[key] = value.toString();
    });
    return Uri.parse('$_baseUrl$path').replace(queryParameters: q.isEmpty ? null : q);
  }

  Future<Map<String, dynamic>> getJson(String path, {Map<String, dynamic>? query}) async {
    final res = await _client.get(_uri(path, query));
    _check(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> getJsonList(String path, {Map<String, dynamic>? query}) async {
    final res = await _client.get(_uri(path, query));
    _check(res);
    final v = jsonDecode(res.body);
    if (v is List) return v;
    throw Exception('Expected list response');
  }

  Future<Map<String, dynamic>> postJson(String path, {Object? body, Map<String, dynamic>? query}) async {
    final res = await _client.post(_uri(path, query), headers: _jsonHeaders, body: jsonEncode(body ?? {}));
    _check(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> putJson(String path, {Object? body}) async {
    final res = await _client.put(_uri(path), headers: _jsonHeaders, body: jsonEncode(body ?? {}));
    _check(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> patchJson(String path, {Object? body, Map<String, dynamic>? query}) async {
    final res = await _client.patch(_uri(path, query), headers: _jsonHeaders, body: jsonEncode(body ?? {}));
    _check(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<void> delete(String path) async {
    final res = await _client.delete(_uri(path));
    _check(res);
  }

  void _check(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
      };
}

class Paged<T> {
  final List<T> content;
  final int page;
  final int size;
  final int totalPages;
  final int totalElements;

  Paged({required this.content, required this.page, required this.size, required this.totalPages, required this.totalElements});

  factory Paged.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    final items = (json['content'] as List).cast<dynamic>().map((e) => fromJson((e as Map).cast<String, dynamic>())).toList();
    return Paged(
      content: items,
      page: json['number'] as int? ?? 0,
      size: json['size'] as int? ?? items.length,
      totalPages: json['totalPages'] as int? ?? 1,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? items.length,
    );
  }
}

