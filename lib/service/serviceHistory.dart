import 'dart:convert';
import 'dart:developer';

import 'package:polkawallet_plugin_evm/polkawallet_plugin_evm.dart';
import 'package:polkawallet_plugin_evm/service/walletApi.dart';
import 'package:polkawallet_plugin_evm/store/index.dart';
import 'package:polkawallet_plugin_evm/store/types/historyData.dart';

class ServiceHistory {
  ServiceHistory(this.plugin);
  final PluginEvm plugin;

  Future<List<HistoryData>?> getHistory(String contractaddress) async {
    if (plugin.service!.keyring.current.address == null) {
      return null;
    }
    if (plugin.store!.history
                .historyMaps[plugin.service!.keyring.current.address!] !=
            null &&
        plugin.store!.history.historyMaps[
                plugin.service!.keyring.current.address!]![contractaddress] !=
            null) {
      return plugin.store!.history.historyMaps[
          plugin.service!.keyring.current.address!]![contractaddress];
    }
    final data = await WalletApi.getHistory(plugin.network,
        plugin.service!.keyring.current.address!, contractaddress);
    if (data != null && data['result'] != null) {
      try {
        final list = (data['result'] as List)
            .map((e) => HistoryData.fromJson(e))
            .toList();
        plugin.store!.history.setHistoryMaps(
            list, contractaddress, plugin.service!.keyring.current.address!);
        return list;
      } catch (_) {}
    }
    return null;
  }

  Future<List<HistoryData>?> getNativeTokenHistory(
      String contractaddress) async {
    if (plugin.service!.keyring.current.address == null) {
      return null;
    }
    if (plugin.store!.history
                .historyMaps[plugin.service!.keyring.current.address!] !=
            null &&
        plugin.store!.history.historyMaps[
                plugin.service!.keyring.current.address!]![contractaddress] !=
            null) {
      return plugin.store!.history.historyMaps[
          plugin.service!.keyring.current.address!]![contractaddress];
    }
    final data = await WalletApi.getNativeTokenHistory(
        plugin.network, plugin.service!.keyring.current.address!);
    if (data != null && data['result'] != null) {
      try {
        final list = (data['result'] as List)
            .map((e) => HistoryData.fromJson(e))
            .toList();
        plugin.store!.history.setHistoryMaps(
            list, contractaddress, plugin.service!.keyring.current.address!);
        return list;
      } catch (_) {}
    }
    return null;
  }
}
