// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AssetsStore on _AssetsStore, Store {
  final _$customAssetsAtom = Atom(name: '_AssetsStore.customAssets');

  @override
  Map<String, bool> get customAssets {
    _$customAssetsAtom.reportRead();
    return super.customAssets;
  }

  @override
  set customAssets(Map<String, bool> value) {
    _$customAssetsAtom.reportWrite(value, super.customAssets, () {
      super.customAssets = value;
    });
  }

  final _$tokenBalanceMapAtom = Atom(name: '_AssetsStore.tokenBalanceMap');

  @override
  Map<String?, TokenBalanceData> get tokenBalanceMap {
    _$tokenBalanceMapAtom.reportRead();
    return super.tokenBalanceMap;
  }

  @override
  set tokenBalanceMap(Map<String?, TokenBalanceData> value) {
    _$tokenBalanceMapAtom.reportWrite(value, super.tokenBalanceMap, () {
      super.tokenBalanceMap = value;
    });
  }

  final _$loadAccountCacheAsyncAction =
      AsyncAction('_AssetsStore.loadAccountCache');

  @override
  Future<void> loadAccountCache(KeyPairData acc) {
    return _$loadAccountCacheAsyncAction.run(() => super.loadAccountCache(acc));
  }

  final _$loadCacheAsyncAction = AsyncAction('_AssetsStore.loadCache');

  @override
  Future<void> loadCache(KeyPairData acc) {
    return _$loadCacheAsyncAction.run(() => super.loadCache(acc));
  }

  final _$_AssetsStoreActionController = ActionController(name: '_AssetsStore');

  @override
  void setTokenBalanceMap(List<TokenBalanceData> list, String? address,
      {bool shouldCache = true}) {
    final _$actionInfo = _$_AssetsStoreActionController.startAction(
        name: '_AssetsStore.setTokenBalanceMap');
    try {
      return super.setTokenBalanceMap(list, address, shouldCache: shouldCache);
    } finally {
      _$_AssetsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCustomAssets(
      KeyPairData acc, String pluginName, Map<String, bool> data) {
    final _$actionInfo = _$_AssetsStoreActionController.startAction(
        name: '_AssetsStore.setCustomAssets');
    try {
      return super.setCustomAssets(acc, pluginName, data);
    } finally {
      _$_AssetsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
customAssets: ${customAssets},
tokenBalanceMap: ${tokenBalanceMap}
    ''';
  }
}
