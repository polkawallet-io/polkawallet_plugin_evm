import 'package:polkawallet_plugin_evm/polkawallet_plugin_evm.dart';
import 'package:polkawallet_plugin_evm/service/serviceHistory.dart';
import 'package:polkawallet_sdk/storage/keyringEVM.dart';

class PluginService {
  PluginService(this.keyring, this.plugin) : history = ServiceHistory(plugin);
  final KeyringEVM keyring;
  final ServiceHistory history;
  final PluginEvm plugin;
}
