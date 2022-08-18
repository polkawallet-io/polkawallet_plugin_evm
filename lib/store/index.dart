import 'package:get_storage/get_storage.dart';
import 'package:polkawallet_plugin_evm/polkawallet_plugin_evm.dart';
import 'package:polkawallet_plugin_evm/store/assets.dart';
import 'package:polkawallet_plugin_evm/store/cache/storeCache.dart';

class PluginStore {
  PluginStore(this.plugin);
  final PluginEvm plugin;

  late final StoreCache _cache;

  late final AssetsStore assets;

  init() {
    _cache = StoreCache();
    _cache.init(plugin.basic.name ?? "plugin_evm");
    assets = AssetsStore(_cache);
  }
}
