// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AccountStore on _AccountStore, Store {
  final _$substratePubKeyAtom = Atom(name: '_AccountStore.substratePubKey');

  @override
  String? get substratePubKey {
    _$substratePubKeyAtom.reportRead();
    return super.substratePubKey;
  }

  @override
  set substratePubKey(String? value) {
    _$substratePubKeyAtom.reportWrite(value, super.substratePubKey, () {
      super.substratePubKey = value;
    });
  }

  @override
  String toString() {
    return '''
substratePubKey: ${substratePubKey}
    ''';
  }
}