// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AccountStore on _AccountStore, Store {
  final _$substrateAtom = Atom(name: '_AccountStore.substrate');

  @override
  KeyPairData? get substrate {
    _$substrateAtom.reportRead();
    return super.substrate;
  }

  @override
  set substrate(KeyPairData? value) {
    _$substrateAtom.reportWrite(value, super.substrate, () {
      super.substrate = value;
    });
  }

  final _$setSubstrateAsyncAction = AsyncAction('_AccountStore.setSubstrate');

  @override
  Future<void> setSubstrate(KeyPairData? substrate, KeyPairData? current) {
    return _$setSubstrateAsyncAction
        .run(() => super.setSubstrate(substrate, current));
  }

  final _$loadCacheAsyncAction = AsyncAction('_AccountStore.loadCache');

  @override
  Future<void> loadCache(KeyPairData acc) {
    return _$loadCacheAsyncAction.run(() => super.loadCache(acc));
  }

  @override
  String toString() {
    return '''
substrate: ${substrate}
    ''';
  }
}
