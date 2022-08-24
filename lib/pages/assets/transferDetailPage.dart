import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_evm/common/constants.dart';
import 'package:polkawallet_plugin_evm/polkawallet_plugin_evm.dart';
import 'package:polkawallet_plugin_evm/store/types/historyData.dart';
import 'package:polkawallet_plugin_evm/utils/i18n/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/txDetail.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:intl/intl.dart';

class TransferDetailPage extends StatelessWidget {
  TransferDetailPage(this.plugin);
  final PluginEvm plugin;

  static final String route = '/assets/token/tx';

  @override
  Widget build(BuildContext context) {
    final Map<String, String> dic =
        I18n.of(context)!.getDic(i18n_full_dic_evm, 'assets')!;

    final HistoryData tx =
        ModalRoute.of(context)!.settings.arguments as HistoryData;

    final String? txType = tx.from == plugin.service!.keyring.current.address
        ? dic['transfer']
        : dic['receive'];

    String? networkName = plugin.basic.name;
    if (plugin.basic.isTestNet) {
      networkName = '${networkName!.split('-')[0]}-testnet';
    }
    return TxDetail(
      current: plugin.service!.keyring.current.toKeyPairData(),
      success: tx.isError != null ? tx.isError == '0' : true,
      action: txType,
      scanName: network_url_scan[plugin.network]!['name'],
      scanLink: "${network_url_scan[plugin.network]!['url']}/tx/${tx.hash}",
      // blockNum: int.parse(tx.block),
      hash: tx.hash,
      blockTime: Fmt.dateTime(DateTime.fromMillisecondsSinceEpoch(
          int.parse(tx.timeStamp!) * 1000,
          isUtc: true)),
      networkName: networkName,
      infoItems: <TxDetailInfoItem>[
        TxDetailInfoItem(
          label: dic['amount'],
          content: Text(
            '${tx.from == plugin.service!.keyring.current.address ? '-' : '+'}${Fmt.balance(tx.value, int.tryParse(tx.tokenDecimal ?? "") ?? 12, length: 6)} ${tx.tokenName}',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        TxDetailInfoItem(
          label: 'From',
          content: Text(Fmt.address(tx.from)),
          copyText: tx.from,
        ),
        TxDetailInfoItem(
          label: 'To',
          content: Text(Fmt.address(tx.to)),
          copyText: tx.to,
        )
      ],
    );
  }
}
