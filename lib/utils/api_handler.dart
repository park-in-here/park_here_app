// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:park_in_here/utils/app_exceptions.dart';
import 'package:park_in_here/utils/toast.dart';

class ApiBaseHelper {
  Future<dynamic> post(String url, Object body) async {
    final link = Uri.parse(url);
    final data = jsonEncode(body);
    final head = {"Content-Type": "application/json"};

    try {
      final response = await http
          .post(link, headers: head, body: data)
          .timeout(const Duration(seconds: 10));

      return _returnResponse(response);
    } on TimeoutException {
      showToast(
        message: "Request timed out. Please try again.",
        backgroundColor: Colors.red,
      );
      throw UniversalException('Timeout');
    } on SocketException {
      showToast(
        message: "No internet connection.",
        backgroundColor: Colors.red,
      );
      throw UniversalException('No internet');
    } catch (e) {
      showToast(
        message: "Something went wrong.",
        backgroundColor: Colors.red,
      );
      throw UniversalException('Unknown error');
    }
  }

  Future<dynamic> get(String url, String accessToken) async {
    final link = Uri.parse(url);
    final head = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    };

    try {
      final response = await http
          .get(link, headers: head)
          .timeout(const Duration(seconds: 10));

      return _returnResponse(response);
    } on TimeoutException {
      showToast(
        message: "Request timed out. Please try again.",
        backgroundColor: Colors.red,
      );
      throw UniversalException('Timeout');
    } on SocketException {
      showToast(
        message: "No internet connection.",
        backgroundColor: Colors.red,
      );
      throw UniversalException('No internet');
    } catch (e) {
      showToast(
        message: "Something went wrong.$e",
        backgroundColor: Colors.red,
      );
      throw UniversalException('Unknown error');
    }
  }

  Future<dynamic> delete(String url, String accessToken) async {
    var responseJson;
    var link = Uri.parse(url);
    var token = accessToken;
    var head = {"Content-Type": "application/json", "x-access-token": token};
    try {
      final response = await http.delete(link, headers: head);

      responseJson = _returnMessage(response);
      responseJson = _returnResponse(response);
    } on SocketException {
      Fluttertoast.showToast(
        msg: "No Internet connection",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
      throw UniversalException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String url, String accessToken, Object body) async {
    var responseJson;
    var link = Uri.parse(url);
    var data = jsonEncode(body);
    var head = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    try {
      final response = await http.put(link, headers: head, body: data);
      // responseJson = _returnMessage(response);
      responseJson = _returnResponse(response);
    } on SocketException {
      Fluttertoast.showToast(
        msg: "No Internet connection",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
      throw UniversalException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postV2(String url, String accessToken, Object body) async {
    final link = Uri.parse(url);
    final data = jsonEncode(body);
    final head = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    };

    try {
      final response = await http
          .post(link, headers: head, body: data)
          .timeout(const Duration(seconds: 10));

      return _returnResponse(response);
    } on TimeoutException {
      showToast(
        message: "Request timed out. Please try again.",
        backgroundColor: Colors.red,
      );
      throw UniversalException('Timeout');
    } on SocketException {
      showToast(
        message: "No internet connection.",
        backgroundColor: Colors.red,
      );
      throw UniversalException('No internet');
    } catch (e) {
      showToast(
        message: "Something went wrong.",
        backgroundColor: Colors.red,
      );
      throw UniversalException('Unknown error');
    }
  }

  Future<dynamic> putV2(String url, String accessToken) async {
    var responseJson;
    var link = Uri.parse(url);

    var head = {
      "Content-Type": "application/json",
      "x-access-token": accessToken
    };
    try {
      final response = await http.put(link, headers: head);
      // responseJson = _returnMessage(response);
      responseJson = _returnResponse(response);
    } on SocketException {
      Fluttertoast.showToast(
        msg: "No Internet connection",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
      throw UniversalException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    } else if (response.statusCode == 201) {
      log(response.statusCode.toString());
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    } else {
      throw UniversalException(
          "${response.body.toString()} : ${response.statusCode}");
    }
    /*  switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 401:
      case 403:
        throw UnauthorisedException(
            "${response.body.toString()} : ${response.statusCode}");
      case 404:
        throw InvalidInputException(
            "Invalid Input Found : ${response.statusCode}");
      case 502:
        throw InvalidInputException(
            "Invalid Input Found : ${response.statusCode}");
      case 500:
        throw BadGateway("Bad Gateway : ${response.statusCode}");
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }*/
  }

  dynamic _returnMessage(http.Response response) {
    var body = jsonDecode(response.body);
    switch (response.statusCode) {
      case 400:
        return Fluttertoast.showToast(
          msg: "${body['message']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16,
        );
      case 404:
        return Fluttertoast.showToast(
          msg: "Invalid Input",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16,
        );
      case 502:
        return Fluttertoast.showToast(
          msg: "Server Error\nPlease Try Again After Some Time",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16,
        );
    }
  }
}
