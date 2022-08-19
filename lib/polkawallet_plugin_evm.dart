library polkawallet_plugin_evm;

import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_evm/common/constants.dart';
import 'package:polkawallet_plugin_evm/pages/assets/manageAssetsPage.dart';
import 'package:polkawallet_plugin_evm/service/walletApi.dart';
import 'package:polkawallet_plugin_evm/store/index.dart';
import 'package:polkawallet_sdk/plugin/homeNavItem.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/keyringEVM.dart';
import 'package:polkawallet_sdk/plugin/store/balances.dart';
import 'package:get_storage/src/storage_impl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginLoadingWidget.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';

class PluginEvm extends PolkawalletPlugin {
  PluginEvm({networkName = network_acala})
      : basic = PluginBasicData(
            name: "evm-$networkName",
            icon: getIcon(networkName),
            primaryColor: _createMaterialColor(const Color(0xFF10B95D)),
            gradientColor: const Color(0xFF9ABD16),
            jsCodeVersion: 33401,
            isTestNet: false),
        network = networkName;
  @override
  final PluginBasicData basic;

  String network;

  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch as Map<int, Color>);
  }

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
      ManageAssetsPage.route: (_) => ManageAssetsPage(this),
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

  @override
  List<TokenBalanceData> get noneNativeTokensAll {
    return store?.assets.tokenBalanceMap.values.toList() ?? [];
  }

  PluginStore? _store;
  PluginStore? get store => _store;
  bool connected = false;

  @override
  Future<void> onWillStartEVM(KeyringEVM keyring) async {
    tokenIcons = _getTokenIcons();

    // _api = AcalaApi(AcalaService(this));

    await GetStorage.init(this.basic.name ?? "plugin_evm");
    _store = PluginStore(this);
    _store!.init();

    _loadAccoundData(keyring.current.toKeyPairData());
    await _loadWallet();
    // _service = PluginService(this, keyring);

    // _loadCacheData(keyring.current);

    // // fetch tokens config here for subscribe all tokens balances
    // _service!.fetchRemoteConfig();
    // _service!.assets.queryIconsSrc();

    // _service!.earn.getBlockDuration();
    //
  }

  @override
  Future<void> onStartedEVM(KeyringEVM keyring) async {
    connected = true;
    if (keyring.current.address != null) {
      updateBalance(keyring.current.toKeyPairData());
      _getSubstrateAccount(keyring.current.toKeyPairData());
    }
  }

  @override
  Future<void> onAccountChanged(KeyPairData acc) async {
    _loadAccoundData(acc);

    if (connected) {
      updateBalance(acc);
      _getSubstrateAccount(acc);
    }
  }

  Future<void> _getSubstrateAccount(KeyPairData acc) async {
    await sdk.api.bridge.init();
    await sdk.api.bridge.connectFromChains([
      network
    ], nodeList: {
      network: [substrate_node_list[network]!]
    });

    final data = await sdk.api.bridge.service.evalJavascript(
        'bridge.getApi("${network.toLowerCase()}").query.evmAccounts.accounts("${acc.address}")');
    if (data != null) {
      try {
        final publicKeys = await sdk.api.account.decodeAddress([data]);
        store!.account.substratePubKey = publicKeys?.values.first;
      } catch (_) {
        store!.account.substratePubKey = "";
      }
    } else {
      store!.account.substratePubKey = "";
    }

    sdk.api.bridge.disconnectFromChains();
    sdk.api.bridge.dispose();
  }

  Future<void> updateBalance(KeyPairData acc) async {
    final tokenBalance = await sdk.api.eth.account.getTokenBalance(
        acc.address!, noneNativeTokensAll.map((e) => e.id!).toList());
    store!.assets.setTokenBalanceMap(
        List<TokenBalanceData>.from(tokenBalance!.map((e) => TokenBalanceData(
              id: e['contractAddress'],
              tokenNameId: e['contractAddress'],
              symbol: e['symbol'],
              name: e['symbol'].toString().toUpperCase(),
              fullName: e['name'],
              decimals: e['decimals'],
              amount: e['amount'],
            ))),
        acc.address);
    balances.isTokensFromCache = false;
  }

  void _loadAccoundData(KeyPairData acc) {
    store!.assets.loadCache(acc);
    balances.isTokensFromCache = true;
  }

  Future<void> _loadWallet() async {
    final data = await WalletApi.getTokenIcons();
    if (data != null) {
      tokenIcons.addAll(data.map((k, v) {
        return MapEntry(
            (k as String).toUpperCase(),
            (v as String).contains('.svg')
                ? SvgPicture.network(
                    v,
                    placeholderBuilder: (context) =>
                        const PluginLoadingWidget(),
                  )
                : Image.network(
                    v,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const PluginLoadingWidget(),
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                  ));
      }));
    }
  }
}
