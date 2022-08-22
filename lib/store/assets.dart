import 'package:get_storage/get_storage.dart';
import 'package:mobx/mobx.dart';
import 'package:polkawallet_plugin_evm/store/cache/storeCache.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/plugin/store/balances.dart';

part 'assets.g.dart';

class AssetsStore extends _AssetsStore with _$AssetsStore {
  AssetsStore(StoreCache storage) : super(storage);
}

abstract class _AssetsStore with Store {
  _AssetsStore(this.cache);

  // final GetStorage storage;

  final StoreCache? cache;

  final String customAssetsStoreKey = 'assets_list';
  final String balanceKey = 'balance_key';

  @observable
  Map<String, bool> customAssets = {};

  @observable
  Map<String?, TokenBalanceData> tokenBalanceMap = <String, TokenBalanceData>{};

  @action
  Future<void> setTokenBalanceMap(List<TokenBalanceData> list, String? address,
      {bool shouldCache = true}) async {
    final data = <String?, TokenBalanceData>{};
    final Map<dynamic, Map> dataForCache = {};
    for (var e in list) {
      if (e.tokenNameId == null) continue;

      data[e.tokenNameId] = e;

      dataForCache[e.tokenNameId] = {
        'id': e.id,
        'name': e.name,
        'symbol': e.symbol,
        'type': e.type,
        'tokenNameId': e.tokenNameId,
        'currencyId': e.currencyId,
        'src': e.src,
        'fullName': e.fullName,
        'decimals': e.decimals,
        'minBalance': e.minBalance,
        'detailPageRoute': e.detailPageRoute,
      };
    }
    tokenBalanceMap = data;

    if (shouldCache) {
      cache!.tokens.val = dataForCache;
      final data =
          dataForCache.map((key, value) => MapEntry(key, value["amount"]));
      // balance amount
      final cachedAssetsList = (await cache!.storage().read(balanceKey)) ?? {};
      cachedAssetsList[address] = data;
      cache!.storage().write(balanceKey, cachedAssetsList);
    }
  }

  @action
  void setCustomAssets(
      KeyPairData acc, String pluginName, Map<String, bool> data) {
    customAssets = data;

    _storeCustomAssets(acc, pluginName, data);
  }

  @action
  Future<void> loadAccountCache(KeyPairData acc) async {
    // return if currentAccount not exist
    if (acc == null) {
      return;
    }

    final cachedAssetsList = await cache!.storage().read(customAssetsStoreKey);
    if (cachedAssetsList != null && cachedAssetsList[acc.pubKey] != null) {
      customAssets = Map<String, bool>.from(cachedAssetsList[acc.pubKey]);
    } else {
      customAssets = <String, bool>{};
    }
  }

  @action
  Future<void> loadCache(KeyPairData acc) async {
    loadAccountCache(acc);

    final cachedTokens = cache!.tokens.val;
    if (cachedTokens != null) {
      final tokens = cachedTokens.values.toList();
      tokens.retainWhere((e) => e['tokenNameId'] != null);
      final cachedAssetsList = await cache!.storage().read(balanceKey);
      setTokenBalanceMap(
          List<TokenBalanceData>.from(tokens.map((e) => TokenBalanceData(
              id: e['id'],
              name: e['name'],
              symbol: e['symbol'],
              type: e['type'],
              tokenNameId: e['tokenNameId'],
              currencyId: e['currencyId'],
              src: e['src'],
              fullName: e['fullName'],
              decimals: e['decimals'],
              minBalance: e['minBalance'],
              amount: cachedAssetsList != null &&
                      cachedAssetsList[acc.address] != null &&
                      cachedAssetsList[acc.address][e['tokenNameId']] != null
                  ? cachedAssetsList[acc.address][e['tokenNameId']]
                  : "0",
              detailPageRoute: e['detailPageRoute']))),
          acc.address,
          shouldCache: false);
    } else {
      tokenBalanceMap = <String, TokenBalanceData>{};
    }
  }

  Future<void> _storeCustomAssets(
      KeyPairData acc, String pluginName, Map<String, bool> data) async {
    final cachedAssetsList =
        (await cache!.storage().read(customAssetsStoreKey)) ?? {};
    cachedAssetsList[acc.pubKey] = data;

    cache!.storage().write(customAssetsStoreKey, cachedAssetsList);
  }
}
