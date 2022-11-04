import 'package:polkawallet_plugin_evm/polkawallet_plugin_evm.dart';
import 'package:polkawallet_plugin_evm/store/account.dart';
import 'package:polkawallet_plugin_evm/store/assets.dart';
import 'package:polkawallet_plugin_evm/store/cache/storeCache.dart';

class PluginStore {
  PluginStore(this.plugin);
  final PluginEvm plugin;

  late final StoreCache _cache;

  late final AssetsStore assets;

  late final AccountStore account;

  init() {
    _cache = StoreCache();
    _cache.init(plugin.basic.name ?? "plugin_evm");
    assets = AssetsStore(_cache);
    account = AccountStore(_cache);
  }
}
