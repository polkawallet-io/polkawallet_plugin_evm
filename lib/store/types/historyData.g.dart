// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historyData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryData _$HistoryDataFromJson(Map<String, dynamic> json) {
  return HistoryData(
    json['value'] as String?,
    json['blockHash'] as String?,
    json['blockNumber'] as String?,
    json['confirmations'] as String?,
    json['contractAddress'] as String?,
    json['cumulativeGasUsed'] as String?,
    json['from'] as String?,
    json['gas'] as String?,
    json['gasPrice'] as String?,
    json['gasUsed'] as String?,
    json['hash'] as String?,
    json['input'] as String?,
    json['logIndex'] as String?,
    json['nonce'] as String?,
    json['timeStamp'] as String?,
    json['to'] as String?,
    json['tokenDecimal'] as String?,
    json['tokenName'] as String?,
    json['tokenSymbol'] as String?,
    json['transactionIndex'] as String?,
    json['isError'] as String?,
  );
}

Map<String, dynamic> _$HistoryDataToJson(HistoryData instance) =>
    <String, dynamic>{
      'value': instance.value,
      'blockHash': instance.blockHash,
      'blockNumber': instance.blockNumber,
      'confirmations': instance.confirmations,
      'contractAddress': instance.contractAddress,
      'cumulativeGasUsed': instance.cumulativeGasUsed,
      'from': instance.from,
      'gas': instance.gas,
      'gasPrice': instance.gasPrice,
      'gasUsed': instance.gasUsed,
      'hash': instance.hash,
      'input': instance.input,
      'logIndex': instance.logIndex,
      'nonce': instance.nonce,
      'timeStamp': instance.timeStamp,
      'to': instance.to,
      'tokenDecimal': instance.tokenDecimal,
      'tokenName': instance.tokenName,
      'tokenSymbol': instance.tokenSymbol,
      'transactionIndex': instance.transactionIndex,
      'isError': instance.isError,
    };
