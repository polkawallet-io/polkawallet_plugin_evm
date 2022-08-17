import 'package:get_storage/get_storage.dart';
import 'package:mobx/mobx.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';

part 'assets.g.dart';

class AssetsStore extends _AssetsStore with _$AssetsStore {
  AssetsStore(GetStorage storage) : super(storage);
}

abstract class _AssetsStore with Store {
  _AssetsStore(this.storage);

  final GetStorage storage;

  final String customAssetsStoreKey = 'assets_list';

  @observable
  Map<String, bool> customAssets = {};

  @action
  void setCustomAssets(
      KeyPairData acc, String pluginName, Map<String, bool> data) {
    customAssets = data;

    _storeCustomAssets(acc, pluginName, data);
  }

  @action
  Future<void> loadAccountCache(KeyPairData acc, String pluginName) async {
    // return if currentAccount not exist
    if (acc == null) {
      return;
    }

    final cachedAssetsList =
        await storage.read('${pluginName}_$customAssetsStoreKey');
    if (cachedAssetsList != null && cachedAssetsList[acc.pubKey] != null) {
      customAssets = Map<String, bool>.from(cachedAssetsList[acc.pubKey]);
    } else {
      customAssets = Map<String, bool>();
    }
  }

  @action
  Future<void> loadCache(KeyPairData acc, String pluginName) async {
    loadAccountCache(acc, pluginName);
  }

  Future<void> _storeCustomAssets(
      KeyPairData acc, String pluginName, Map<String, bool> data) async {
    final cachedAssetsList =
        (await storage.read('${pluginName}_$customAssetsStoreKey')) ?? {};

    cachedAssetsList[acc.pubKey] = data;

    storage.write('${pluginName}_$customAssetsStoreKey', cachedAssetsList);
  }
}
