library polkawallet_plugin_evm;

import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_evm/common/constants.dart';
import 'package:polkawallet_sdk/plugin/homeNavItem.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

class PluginEvm extends PolkawalletPlugin {
  PluginEvm({networkName = 'acala'})
      : basic = PluginBasicData(
          name: "evm-$networkName",
          icon: getIcon(networkName),
          jsCodeVersion: 33401,
        ),
        network = networkName;
  @override
  final PluginBasicData basic;

  String network;

  @override
  List<HomeNavItem> getNavItems(BuildContext context, Keyring keyring) {
    // TODO: implement getNavItems
    return [
      HomeNavItem(
        text: "test",
        icon: Container(),
        iconActive: Container(),
        isAdapter: true,
        content: Container(),
      ),
    ];
  }

  @override
  Map<String, WidgetBuilder> getRoutes(Keyring keyring) {
    // TODO: implement getRoutes
    return {};
  }

  @override
  Future<String>? loadJSCode() => null;

  @override
  List<NetworkParams> get nodeList {
    return network_node_list[this.network]!
        .map((e) => NetworkParams.fromJson(e))
        .toList();
  }

  @override
  // TODO: implement tokenIcons
  Map<String, Widget> get tokenIcons => {};

  List<String> networkList() {
    return network_node_list.keys.toList();
  }

  static Widget getIcon(networkName) {
    switch (networkName) {
      case 'karura':
        return Image.asset(
            'packages/polkawallet_plugin_evm/assets/images/networkIcon/KAR.png');
      case 'acala':
        return Image.asset(
            'packages/polkawallet_plugin_evm/assets/images/networkIcon/ACA.png');
    }
    return Image.asset(
        'packages/polkawallet_plugin_evm/assets/images/networkIcon/ACA.png');
  }
}
