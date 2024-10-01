import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:io';

class Session {
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'Accept': "*/*",
  };

  Map<String, String> cookies = {};

  Future<dynamic> get(String url, String unencodedPath, Map<String, dynamic> queryParams, bool isJson) async{
    print('get() url: $url');

    // final uri = Uri.parse(Uri.encodeFull(url));
    // print('uri before');
    // print(uri.queryParameters);
    // uri.replace(queryParameters: {
    //     ...uri.queryParameters,
    //     ...queryParams,
    //   },);
    
    // print('uri after');
    // print(uri.queryParameters);
    
    if (isJson) {
      final uri = Uri.http(url, unencodedPath, queryParams);

      final response = await http.get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      final int statusCode = response.statusCode;
      // print(response.body);
      print(statusCode);
      print(response);
      // print(utf8.decode(response.bodyBytes));S
      return jsonDecode(response.body);
    }
    else {
      final uri = Uri.http(url, unencodedPath, queryParams);

      final response = await http.get(uri);

      final int statusCode = response.statusCode;
      // print(response.body);
      print(statusCode);
      // print(utf8.decode(response.bodyBytes));S
      return response.body;
    }
  }

  Future<dynamic> post(String url, String filepath) async{
    print('post() url: $url');
    var request = new http.MultipartRequest('post', Uri.parse(Uri.encodeFull(url)));
    request.fields['user'] = 'blah';
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath('file', filepath);
    request.files.add(
      multipartFile
    );
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    final int statusCode = response.statusCode;
    // print(response.body);
    print(statusCode);
    print(response);
    // print(utf8.decode(response.bodyBytes));
    
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}