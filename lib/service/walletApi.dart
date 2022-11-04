import 'dart:convert';

import 'package:http/http.dart';
import 'package:polkawallet_plugin_evm/common/constants.dart';

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
      String network, String address, String contractaddress) async {
    final url =
        '${block_explorer_url[network]}/api?module=account&action=tokentx&address=$address&contractaddress=$contractaddress&sort=desc';
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

  static Future<Map?> getNativeTokenHistory(
      String network, String address) async {
    final url =
        '${block_explorer_url[network]}/api?module=account&action=txlist&address=$address&sort=desc';
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
