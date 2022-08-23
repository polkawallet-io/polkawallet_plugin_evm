import 'dart:convert';

import 'package:polkawallet_plugin_evm/store/cache/storeCache.dart';
import 'package:mobx/mobx.dart';
import 'package:polkawallet_plugin_evm/store/types/historyData.dart';

part 'history.g.dart';

class HistoryStore extends _HistoryStore with _$HistoryStore {
  HistoryStore(StoreCache storage) : super(storage);
}

abstract class _HistoryStore with Store {
  _HistoryStore(this.cache);

  final StoreCache? cache;

  @observable
  Map<String, Map<String, List<HistoryData>>> historyMaps =
      <String, Map<String, List<HistoryData>>>{};

  @action
  void setHistoryMaps(
      List<HistoryData> data, String contractaddress, String address) {
    final historyDatas = historyMaps;
    if (historyDatas[address] != null) {
      historyDatas[address]![contractaddress] = data;
    } else {
      historyDatas[address] = {contractaddress: data};
    }
    historyMaps = historyDatas;
  }
}
