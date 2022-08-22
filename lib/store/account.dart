import 'package:get_storage/get_storage.dart';
import 'package:mobx/mobx.dart';
import 'package:polkawallet_plugin_evm/store/cache/storeCache.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';

part 'account.g.dart';

class AccountStore extends _AccountStore with _$AccountStore {
  AccountStore(StoreCache storage) : super(storage);
}

abstract class _AccountStore with Store {
  _AccountStore(this.cache);

  final StoreCache? cache;

  @observable
  KeyPairData? substrate;

  @action
  Future<void> setSubstrate(KeyPairData substrate) async {
    this.substrate = substrate;
  }
}
