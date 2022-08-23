import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_plugin_evm/polkawallet_plugin_evm.dart';
import 'package:polkawallet_plugin_evm/store/types/historyData.dart';
import 'package:polkawallet_plugin_evm/utils/i18n/index.dart';
import 'package:polkawallet_sdk/plugin/store/balances.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/TransferIcon.dart';
import 'package:polkawallet_ui/components/listTail.dart';
import 'package:polkawallet_ui/components/tokenIcon.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/borderedTitle.dart';
import 'package:polkawallet_ui/components/v3/cardButton.dart';
import 'package:polkawallet_ui/components/v3/dialog.dart';
import 'package:polkawallet_ui/components/v3/iconButton.dart' as v3;
import 'package:polkawallet_ui/components/v3/plugin/pluginLoadingWidget.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';
import 'package:polkawallet_ui/pages/accountQrCodePage.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:intl/intl.dart';

class TokenDetailPage extends StatefulWidget {
  const TokenDetailPage(this.plugin, {Key? key}) : super(key: key);
  final PluginEvm plugin;
  // final Keyring keyring;

  static const String route = '/assets/token/detail';

  @override
  _TokenDetailPageSate createState() => _TokenDetailPageSate();
}

class _TokenDetailPageSate extends State<TokenDetailPage> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      new GlobalKey<RefreshIndicatorState>();

  int _txFilterIndex = 0;
  bool isLoadHistory = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getHistory();
    });
  }

  Future<void> getHistory() async {
    final TokenBalanceData token =
        ModalRoute.of(context)!.settings.arguments as TokenBalanceData;
    if (token.id == token.symbol) {
      //NativeToken
      await widget.plugin.service!.history.getNativeTokenHistory(token.id!);
    } else {
      await widget.plugin.service!.history.getHistory(token.id!);
    }
    setState(() {
      isLoadHistory = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_evm, 'assets')!;

    final TokenBalanceData token =
        ModalRoute.of(context)!.settings.arguments as TokenBalanceData;

    final filterOptions = [dic['all'], dic['in'], dic['out']];

    return Scaffold(
      appBar: AppBar(
        title: Text(token.symbol!),
        centerTitle: true,
        elevation: 0.0,
        leading: const BackBtn(),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: v3.IconButton(
                  isBlueBg: true,
                  icon: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).cardColor,
                    size: 22,
                  ),
                  onPressed: () {
                    final snLink =
                        'https://blockscout.${widget.plugin.nodeList.first.endpoint!.split("://").last.split("/").first}/address/${widget.plugin.service!.keyring.current.address}';
                    UI.launchURL(snLink);
                  })),
        ],
      ),
      body: Observer(
        builder: (_) {
          final tokenSymbol = token.symbol;
          final index = widget.plugin.noneNativeTokensAll
              .indexWhere((element) => element.id == token.id);
          final balance = index >= 0
              ? widget.plugin.noneNativeTokensAll
                  .firstWhere((element) => element.id == token.id)
              : TokenBalanceData(
                  amount:
                      widget.plugin.balances.native?.freeBalance?.toString() ??
                          "",
                  decimals: 18,
                  id: widget.plugin.nativeToken.toUpperCase(),
                  symbol: widget.plugin.nativeToken.toUpperCase(),
                  name: widget.plugin.nativeToken.toUpperCase(),
                  fullName:
                      '${widget.plugin.basic.name} ${dic['manage.native']}');
          widget.plugin.store!.assets.customAssets;

          // final tokensConfig =
          //     widget.plugin.store!.setting.remoteConfig['tokens'] ?? {};
          // final disabledTokens = tokensConfig['disabled'];
          // bool transferDisabled = false;
          // if (disabledTokens != null) {
          //   transferDisabled = List.of(disabledTokens).contains(tokenSymbol);
          // }

          final list = widget.plugin.store?.history.historyMaps[
                  widget.plugin.service!.keyring.current.address]?[token.id] ??
              [];
          final txs = list.toList();
          if (_txFilterIndex > 0) {
            txs.retainWhere((e) =>
                (_txFilterIndex == 1 ? e.to : e.from) ==
                widget.plugin.service!.keyring.current.address);
          }

          final titleColor = Theme.of(context).cardColor;
          return RefreshIndicator(
            color: Colors.black,
            backgroundColor: Colors.white,
            key: _refreshKey,
            onRefresh: token.symbol == widget.plugin.nativeToken
                ? () => widget.plugin.updateBalances(
                    widget.plugin.service!.keyring.current.toKeyPairData())
                : () => widget.plugin.updateBalanceNoneNativeToken(token),
            child: Column(
              children: <Widget>[
                BalanceCard(
                  balance,
                  symbol: tokenSymbol ?? '',
                  decimals: token.decimals!,
                  tokenPrice: token.getPrice != null ? token.getPrice!() : 0.0,
                  bgColors: [Color(0xFF303153), Color(0xFF161921)],
                  icon: TokenIcon(
                    token.id ?? "",
                    widget.plugin.tokenIcons,
                    size: 45,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: CardButton(
                              icon: Padding(
                                padding: EdgeInsets.only(left: 3),
                                child: Image.asset(
                                  "packages/polkawallet_plugin_karura/assets/images/send${UI.isDarkTheme(context) ? "_dark" : ""}.png",
                                  width: 32,
                                ),
                              ),
                              text: dic['send']!,
                              onPressed: () {
                                // Navigator.pushNamed(
                                //   context,
                                //   TransferPage.route,
                                //   arguments: {
                                //     'tokenNameId': token.tokenNameId
                                //   },
                                // );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: CardButton(
                              icon: Image.asset(
                                "packages/polkawallet_plugin_karura/assets/images/qr${UI.isDarkTheme(context) ? "_dark" : ""}.png",
                                width: 32,
                              ),
                              text: dic['receive']!,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AccountQrCodePage.route);
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BorderedTitle(title: dic['loan.txs']),
                        Row(
                          children: [
                            Container(
                              width: 36.w,
                              height: 28.h,
                              margin: EdgeInsets.only(right: 8.w),
                              decoration: BoxDecoration(
                                color: UI.isDarkTheme(context)
                                    ? Color(0x52000000)
                                    : Colors.transparent,
                                borderRadius: UI.isDarkTheme(context)
                                    ? BorderRadius.all(Radius.circular(5))
                                    : null,
                                border: UI.isDarkTheme(context)
                                    ? Border.all(
                                        color: Color(0x26FFFFFF), width: 1)
                                    : null,
                                image: UI.isDarkTheme(context)
                                    ? null
                                    : DecorationImage(
                                        image: AssetImage(
                                            "assets/images/bg_tag.png"),
                                        fit: BoxFit.fill),
                              ),
                              child: Center(
                                child: Text(filterOptions[_txFilterIndex]!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                            color: UI.isDarkTheme(context)
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .toggleableActiveColor,
                                            fontWeight: FontWeight.w600)),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) {
                                        return PolkawalletActionSheet(
                                          actions: filterOptions.map((e) {
                                            return PolkawalletActionSheetAction(
                                                child: Text(e!),
                                                onPressed: () {
                                                  setState(() {
                                                    _txFilterIndex =
                                                        filterOptions
                                                            .indexOf(e);
                                                  });
                                                  Navigator.pop(context);
                                                });
                                          }).toList(),
                                          cancelButton:
                                              PolkawalletActionSheetAction(
                                            child: Text(dic['cancel']!),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        );
                                      });
                                },
                                child: v3.IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/images/icon_screening.svg',
                                    color: UI.isDarkTheme(context)
                                        ? Colors.white
                                        : Color(0xFF979797),
                                    width: 22.h,
                                  ),
                                ))
                          ],
                        )
                      ],
                    )),
                Expanded(
                  child: Container(
                    color: titleColor,
                    child: isLoadHistory
                        ? Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [PluginLoadingWidget()],
                            ),
                          )
                        : ListView.builder(
                            itemCount: txs.length + 1,
                            itemBuilder: (_, i) {
                              if (i == txs.length) {
                                return ListTail(
                                    isEmpty: txs.length == 0, isLoading: false);
                              }
                              return TransferListItem(
                                data: txs[i],
                                token: token,
                                isOut: txs[i].from ==
                                    widget.plugin.service!.keyring.current
                                        .address,
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget priceItemBuild(Widget icon, String title, String price, Color color,
    BuildContext context) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: 18.w,
              width: 18.w,
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(27),
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: icon),
          Text(
            title,
            style: TextStyle(
                color: color,
                fontSize: UI.getTextSize(12, context),
                fontWeight: FontWeight.w600,
                fontFamily: UI.getFontFamily('TitilliumWeb', context)),
          ),
          Expanded(
            child: Text(
              price,
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: color,
                  fontSize: UI.getTextSize(12, context),
                  fontWeight: FontWeight.w400,
                  fontFamily: UI.getFontFamily('TitilliumWeb', context)),
            ),
          )
        ],
      ));
}

class BalanceCard extends StatelessWidget {
  BalanceCard(
    this.tokenBalance, {
    this.tokenPrice,
    required this.symbol,
    required this.decimals,
    this.bgColors,
    this.icon,
  });

  final String symbol;
  final int decimals;
  final TokenBalanceData? tokenBalance;
  final double? tokenPrice;
  final List<Color>? bgColors;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    // final dic = I18n.of(context)!.getDic(i18n_full_dic_karura, 'common')!;

    final free = Fmt.balanceInt(tokenBalance?.amount ?? '0');
    final locked = Fmt.balanceInt(tokenBalance?.locked ?? '0');
    final reserved = Fmt.balanceInt(tokenBalance?.reserved ?? '0');
    final transferable = free - locked;
    final total = free + reserved;

    double? tokenValue;
    if (tokenPrice != null) {
      tokenValue = (tokenPrice ?? 0) > 0
          ? tokenPrice! *
              Fmt.bigIntToDouble(total, decimals) *
              (tokenBalance?.priceRate ?? 1.0)
          : 0;
    }

    final titleColor =
        UI.isDarkTheme(context) ? Colors.white : Theme.of(context).cardColor;
    final child = Container(
        // padding: EdgeInsets.all(16.w),
        height: 172,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(8)),
          gradient: LinearGradient(
            colors: bgColors ??
                [Theme.of(context).primaryColor, Theme.of(context).hoverColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              // color: primaryColor.withAlpha(100),
              color: Color(0x4D000000),
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(5.0, 5.0),
            )
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Image.asset(
                  "packages/polkawallet_plugin_evm/assets/images/balanceCard.png",
                  width: 110,
                )),
            Padding(
                padding: EdgeInsets.all(22.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(margin: EdgeInsets.only(right: 8), child: icon),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          Fmt.priceFloorBigInt(total, decimals, lengthMax: 8),
                          style: TextStyle(
                              color: titleColor,
                              fontSize: UI.getTextSize(20, context),
                              letterSpacing: -0.8,
                              fontWeight: FontWeight.w600,
                              fontFamily:
                                  UI.getFontFamily('TitilliumWeb', context)),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Visibility(
                          visible: tokenValue != null,
                          child: Text(
                            '≈ ${Fmt.priceCurrencySymbol(tokenBalance?.priceCurrency)} ${Fmt.priceFloor(tokenValue)}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: titleColor,
                                    letterSpacing: -0.8,
                                    fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ));

    return UI.isDarkTheme(context)
        ? RoundedCard(
            margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.w),
            child: child,
          )
        : Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.w), child: child);
  }
}

class TransferListItem extends StatelessWidget {
  TransferListItem({
    this.data,
    this.token,
    this.isOut,
    this.crossChain,
  });

  final HistoryData? data;
  final TokenBalanceData? token;
  final String? crossChain;
  final bool? isOut;

  @override
  Widget build(BuildContext context) {
    final address = isOut! ? data!.to : data!.from;
    final title = isOut!
        ? 'Send to ${Fmt.address(address)}'
        : 'Receive from ${Fmt.address(address)}';
    final amount = Fmt.priceFloorBigInt(
        BigInt.parse(data!.value!), token?.decimals ?? 12,
        lengthMax: 6);

    return ListTile(
      dense: true,
      minLeadingWidth: 32,
      horizontalTitleGap: 8,
      leading: isOut!
          ? TransferIcon(
              type: TransferIconType.rollOut,
              bgColor: Theme.of(context).cardColor)
          : TransferIcon(
              type: TransferIconType.rollIn, bgColor: Color(0xFFD7D7D7)),
      title: Text('$title${crossChain != null ? ' ($crossChain)' : ''}',
          style: Theme.of(context).textTheme.headline4),
      subtitle: Text(Fmt.dateTime(DateTime.fromMillisecondsSinceEpoch(
          int.parse(data!.timeStamp!) * 1000))),
      trailing: Container(
        width: 110,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '${isOut! ? '-' : '+'} $amount',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Theme.of(context).toggleableActiveColor,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // Navigator.pushNamed(
        //   context,
        //   TransferDetailPage.route,
        //   arguments: data,
        // );
      },
    );
  }
}
