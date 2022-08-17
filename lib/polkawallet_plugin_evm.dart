library polkawallet_plugin_evm;

import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_evm/common/constants.dart';
import 'package:polkawallet_plugin_evm/pages/assets/manageAssetsPage.dart';
import 'package:polkawallet_plugin_evm/store/index.dart';
import 'package:polkawallet_sdk/plugin/homeNavItem.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/keyringEVM.dart';

class PluginEvm extends PolkawalletPlugin {
  PluginEvm({networkName = network_acala})
      : basic = PluginBasicData(
            name: "evm-$networkName",
            icon: getIcon(networkName),
            jsCodeVersion: 33401,
            isTestNet: false),
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
    return {
      ManageAssetsPage.route: (_) => ManageAssetsPage(this, _store),
    };
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
  Map<String, Widget> tokenIcons = {};

  String get nativeToken => network_native_token[network]!;

  List<String> networkList() {
    return network_node_list.keys.toList();
  }

  static Widget getIcon(networkName) {
    switch (networkName) {
      case network_karura:
        return Image.asset(
            'packages/polkawallet_plugin_evm/assets/images/networkIcon/KAR.png');
      case network_acala:
        return Image.asset(
            'packages/polkawallet_plugin_evm/assets/images/networkIcon/ACA.png');
    }
    return Image.asset(
        'packages/polkawallet_plugin_evm/assets/images/networkIcon/ACA.png');
  }

  Map<String, Widget> _getTokenIcons() {
    final Map<String, Widget> all = {};
    network_native_token.values.forEach((token) {
      all[token] = Image.asset(
          'packages/polkawallet_plugin_evm/assets/images/tokens/$token.png');
    });
    return all;
  }

  PluginStore? _store;

  @override
  Future<void> onWillStartEVM(KeyringEVM keyring) async {
    tokenIcons = _getTokenIcons();

    // _api = AcalaApi(AcalaService(this));

    // await GetStorage.init(plugin_cache_key);

    // _cache = StoreCache();
    _store = PluginStore(this);
    _store!.init();
    // _service = PluginService(this, keyring);

    // _loadCacheData(keyring.current);

    // // fetch tokens config here for subscribe all tokens balances
    // _service!.fetchRemoteConfig();
    // _service!.assets.queryIconsSrc();

    // _service!.earn.getBlockDuration();
  }
}
