import 'dart:convert';

import 'package:http/http.dart';

class WalletApi {
  static const String _endpoint = 'https://api.polkawallet.io';
  static const String _configEndpoint = 'https://acala.polkawallet-cloud.com';

  static Future<Map?> getTokenIcons() async {
    //TODO:
    // final url = '$_configEndpoint/config/evmTokenIcons.json';
    final url = '$_endpoint/config/evmTokenIcons.json'; //dev
    try {
      Response res = await get(Uri.parse(url));
      if (res == null) {
        return null;
      } else {
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  static Future<Map?> getHistory(
      String node, String address, String contractaddress) async {
    final url =
        'https://blockscout.${node.split("://").last.split("/").first}/api?module=account&action=tokentx&address=$address&contractaddress=$contractaddress';
    try {
      Response res = await get(Uri.parse(url));
      if (res == null) {
        return null;
      } else {
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  static Future<Map?> getNativeTokenHistory(String node, String address) async {
    final url =
        'https://blockscout.${node.split("://").last.split("/").first}/api?module=account&action=txlist&address=$address';
    try {
      Response res = await get(Uri.parse(url));
      if (res == null) {
        return null;
      } else {
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
    } catch (err) {
      print(err);
      return null;
    }
  }
}
