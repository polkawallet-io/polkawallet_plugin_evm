import 'package:get_storage/get_storage.dart';
import 'package:polkawallet_plugin_evm/polkawallet_plugin_evm.dart';
import 'package:polkawallet_plugin_evm/store/assets.dart';

class PluginStore {
  PluginStore(this.plugin);
  final PluginEvm plugin;

  late final GetStorage _storage;

  late final AssetsStore assets;

  init() {
    _storage = GetStorage(plugin.basic.name ?? "plugin_evm");
    assets = AssetsStore(_storage);
  }
}
