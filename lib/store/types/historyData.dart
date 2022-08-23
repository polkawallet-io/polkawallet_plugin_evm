import 'package:json_annotation/json_annotation.dart';

part 'historyData.g.dart';

@JsonSerializable()
class HistoryData {
  final String? value;
  final String? blockHash;
  final String? blockNumber;
  final String? confirmations;
  final String? contractAddress;
  final String? cumulativeGasUsed;
  final String? from;
  final String? gas;
  final String? gasPrice;
  final String? gasUsed;
  final String? hash;
  final String? input;
  final String? logIndex;
  final String? nonce;
  final String? timeStamp;
  final String? to;
  final String? tokenDecimal;
  final String? tokenName;
  final String? tokenSymbol;
  final String? transactionIndex;

  HistoryData(
      this.value,
      this.blockHash,
      this.blockNumber,
      this.confirmations,
      this.contractAddress,
      this.cumulativeGasUsed,
      this.from,
      this.gas,
      this.gasPrice,
      this.gasUsed,
      this.hash,
      this.input,
      this.logIndex,
      this.nonce,
      this.timeStamp,
      this.to,
      this.tokenDecimal,
      this.tokenName,
      this.tokenSymbol,
      this.transactionIndex);

  factory HistoryData.fromJson(Map<String, dynamic> json) =>
      _$HistoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryDataToJson(this);
}
