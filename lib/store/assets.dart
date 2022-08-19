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

  @observable
  Map<String, bool> customAssets = {};

  @observable
  Map<String?, TokenBalanceData> tokenBalanceMap =
      Map<String, TokenBalanceData>();

  @action
  void setTokenBalanceMap(List<TokenBalanceData> list, String? address,
      {bool shouldCache = true}) {
    final data = Map<String?, TokenBalanceData>();
    final dataForCache = {};
    list.forEach((e) {
      if (e.tokenNameId == null) return;

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
        'amount': e.amount,
        'detailPageRoute': e.detailPageRoute,
      };
    });
    tokenBalanceMap = data;

    if (shouldCache) {
      final cached = cache!.tokens.val;
      cached[address] = dataForCache;
      cache!.tokens.val = cached;
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

    final cachedAssetsList =
        await cache!.storage().read('$customAssetsStoreKey');
    if (cachedAssetsList != null && cachedAssetsList[acc.pubKey] != null) {
      customAssets = Map<String, bool>.from(cachedAssetsList[acc.pubKey]);
    } else {
      customAssets = Map<String, bool>();
    }
  }

  @action
  Future<void> loadCache(KeyPairData acc) async {
    loadAccountCache(acc);

    final cachedTokens = cache!.tokens.val;
    if (cachedTokens != null && cachedTokens[acc.address] != null) {
      final tokens = cachedTokens[acc.address].values.toList();
      tokens.retainWhere((e) => e['tokenNameId'] != null);
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
              amount: e['amount'],
              detailPageRoute: e['detailPageRoute']))),
          acc.address,
          shouldCache: false);
    } else {
      tokenBalanceMap = Map<String, TokenBalanceData>();
    }
  }

  Future<void> _storeCustomAssets(
      KeyPairData acc, String pluginName, Map<String, bool> data) async {
    final cachedAssetsList =
        (await cache!.storage().read('$customAssetsStoreKey')) ?? {};
    cachedAssetsList[acc.pubKey] = data;

    cache!.storage().write('$customAssetsStoreKey', cachedAssetsList);
  }
}