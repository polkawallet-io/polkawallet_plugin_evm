import 'package:get_storage/get_storage.dart';
import 'package:polkawallet_plugin_evm/polkawallet_plugin_evm.dart';
import 'package:polkawallet_plugin_evm/store/account.dart';
import 'package:polkawallet_plugin_evm/store/assets.dart';
import 'package:polkawallet_plugin_evm/store/cache/storeCache.dart';
import 'package:polkawallet_plugin_evm/store/history.dart';

class PluginStore {
  PluginStore(this.plugin);
  final PluginEvm plugin;

  late final StoreCache _cache;

  late final AssetsStore assets;

  late final AccountStore account;

  late final HistoryStore history;

  init() {
    _cache = StoreCache();
    _cache.init(plugin.basic.name ?? "plugin_evm");
    assets = AssetsStore(_cache);
    account = AccountStore(_cache);
    history = HistoryStore(_cache);
  }
}
