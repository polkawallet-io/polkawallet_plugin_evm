import 'package:polkawallet_plugin_evm/polkawallet_plugin_evm.dart';
import 'package:polkawallet_sdk/storage/keyringEVM.dart';

class PluginService {
  PluginService(this.keyring, this.plugin);
  final KeyringEVM keyring;
  final PluginEvm plugin;
}
