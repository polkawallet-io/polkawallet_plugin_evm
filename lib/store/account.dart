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

  final String substrateKey = 'substrate_key';

  @observable
  KeyPairData? substrate;

  @action
  Future<void> setSubstrate(
      KeyPairData? substrate, KeyPairData? current) async {
    this.substrate = substrate;
    if (substrate != null) {
      final cachedSubstrate = (await cache!.storage().read(substrateKey)) ?? {};
      cachedSubstrate[current!.address] = substrate.toJson();
      cache!.storage().write(substrateKey, cachedSubstrate);
    }
  }

  @action
  Future<void> loadCache(KeyPairData acc) async {
    final cachedSubstrate = await cache!.storage().read(substrateKey);
    print("loadCache====${cachedSubstrate}");
    if (cachedSubstrate != null && cachedSubstrate[acc.address] != null) {
      substrate = KeyPairData.fromJson(cachedSubstrate[acc.address]);
    }
  }
}
