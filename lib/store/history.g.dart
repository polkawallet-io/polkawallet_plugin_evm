// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HistoryStore on _HistoryStore, Store {
  final _$historyMapsAtom = Atom(name: '_HistoryStore.historyMaps');

  @override
  Map<String, Map<String, List<HistoryData>>> get historyMaps {
    _$historyMapsAtom.reportRead();
    return super.historyMaps;
  }

  @override
  set historyMaps(Map<String, Map<String, List<HistoryData>>> value) {
    _$historyMapsAtom.reportWrite(value, super.historyMaps, () {
      super.historyMaps = value;
    });
  }

  final _$_HistoryStoreActionController =
      ActionController(name: '_HistoryStore');

  @override
  void setHistoryMaps(
      List<HistoryData> data, String contractaddress, String address) {
    final _$actionInfo = _$_HistoryStoreActionController.startAction(
        name: '_HistoryStore.setHistoryMaps');
    try {
      return super.setHistoryMaps(data, contractaddress, address);
    } finally {
      _$_HistoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
historyMaps: ${historyMaps}
    ''';
  }
}
