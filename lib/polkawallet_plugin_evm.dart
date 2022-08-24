library polkawallet_plugin_evm;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_evm/common/constants.dart';
import 'package:polkawallet_plugin_evm/pages/assets/manageAssetsPage.dart';
import 'package:polkawallet_plugin_evm/pages/assets/tokenDetailPage.dart';
import 'package:polkawallet_plugin_evm/pages/assets/transferDetailPage.dart';
import 'package:polkawallet_plugin_evm/service/index.dart';
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
    return [];
  }

  @override
  Map<String, WidgetBuilder> getRoutes(Keyring keyring) {
    return {
      ManageAssetsPage.route: (_) => ManageAssetsPage(this),
      TokenDetailPage.route: (_) => TokenDetailPage(this),
      TransferDetailPage.route: (_) => TransferDetailPage(this),
    };
  }

  @override
  Future<String>? loadJSCode() => null;

  @override
  List<NetworkParams> get nodeList {
    return network_node_list[network]!
        .map((e) => NetworkParams.fromJson(e))
        .toList();
  }

  @override
  Map<String, Widget> tokenIcons = {};

  String get nativeToken => network_native_token[network.toLowerCase()]!;

  List<String> networkList() {
    return network_node_list.keys.toList();
  }

  static Widget getIcon(networkName) {
    return Image.asset(
        'packages/polkawallet_plugin_evm/assets/images/networkIcon/$networkName.png');
  }

  Map<String, Widget> _getTokenIcons() {
    final Map<String, Widget> all = {};
    for (var token in network_native_token.values) {
      all[token] = Image.asset(
          'packages/polkawallet_plugin_evm/assets/images/tokens/${token.toUpperCase().toString()}.png');
    }
    return all;
  }

  @override
  List<TokenBalanceData> get noneNativeTokensAll {
    return store?.assets.tokenBalanceMap.values.toList() ?? [];
  }

  PluginStore? _store;
  PluginStore? get store => _store;
  PluginService? _service;
  PluginService? get service => _service;
  bool connected = false;

  @override
  Future<void> onWillStartEVM(KeyringEVM keyring) async {
    tokenIcons = _getTokenIcons();

    await GetStorage.init(basic.name ?? "plugin_evm");
    _store = PluginStore(this);
    _store!.init();

    _service = PluginService(keyring, this);

    _loadAccoundData(keyring.current.toKeyPairData());
    await _loadWallet();
  }

  @override
  Future<void> onStartedEVM(KeyringEVM keyring) async {
    connected = true;
    if (keyring.current.address != null) {
      updateBalanceNoneNativeTokensAll();
      if (network == network_acala || network == network_karura) {
        _getSubstrateAccount(keyring.current.toKeyPairData());
      }
    }
  }

  @override
  Future<void> onAccountChanged(KeyPairData acc) async {
    store!.account.setSubstrate(null, acc);
    _loadAccoundData(acc);
    if (connected) {
      updateBalanceNoneNativeTokensAll();
      if (network == network_acala || network == network_karura) {
        _getSubstrateAccount(acc);
      }
    }
  }

  Future<void> updateSubstrateAccount() async {
    final acc = service!.keyring.current;
    await _getSubstrateAccount(acc.toKeyPairData());
  }

  Future<void> _getSubstrateAccount(KeyPairData acc) async {
    if (acc.address == null) return;
    store!.account.querying = true;
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
        final publicKey =
            (await sdk.api.account.decodeAddress([data]))?.keys.first;
        final address = await sdk.api.account.service
            .encodeAddress([publicKey!], [substrate_ss58_list[network]]);
        final icons = await sdk.api.account.service.getPubKeyIcons([publicKey]);
        store!.account.setSubstrate(
            KeyPairData()
              ..pubKey = publicKey
              ..address = address!["${substrate_ss58_list[network]}"][publicKey]
              ..icon = (icons!.last as List).last.toString(),
            acc);
      } catch (_) {}
    }

    sdk.api.bridge.disconnectFromChains();
    sdk.api.bridge.dispose();
    store!.account.querying = false;
  }

  Future<void> updateBalanceNoneNativeToken(TokenBalanceData token) async {
    final tokenBalance = await sdk.api.eth.account.getTokenBalance(
        service!.keyring.current.address!, [token.id!.toLowerCase()]);
    noneNativeTokensAll.removeWhere(
        (element) => element.id!.toLowerCase() == token.id!.toLowerCase());
    if (tokenBalance != null && tokenBalance.isNotEmpty) {
      final tokens = noneNativeTokensAll.toList();
      for (var element in tokens) {
        if (element.id!.toLowerCase() == token.id!.toLowerCase()) {
          element.amount = tokenBalance.first['amount'];
        }
      }
      store!.assets
          .setTokenBalanceMap(tokens, service!.keyring.current.address);
    }
  }

  Future<void> updateBalanceNoneNativeTokensAll() async {
    final tokenBalance = await sdk.api.eth.account.getTokenBalance(
        service!.keyring.current.address!,
        noneNativeTokensAll.map((e) => e.id!.toLowerCase()).toList());
    if (tokenBalance != null && tokenBalance.isNotEmpty) {
      final tokens = noneNativeTokensAll.toList();
      for (var element in tokens) {
        for (var e in tokenBalance) {
          if (element.id!.toLowerCase() ==
              e["contractAddress"].toString().toLowerCase()) {
            element.amount = e['amount'];
          }
        }
      }
      store!.assets
          .setTokenBalanceMap(tokens, service!.keyring.current.address);
    }
    balances.isTokensFromCache = false;
  }

  void _loadAccoundData(KeyPairData acc) {
    store!.assets.loadCache(acc);
    store!.account.loadCache(acc);
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
