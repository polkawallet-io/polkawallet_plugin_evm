import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_plugin_evm/common/constants.dart';
import 'package:polkawallet_plugin_evm/polkawallet_plugin_evm.dart';
import 'package:polkawallet_plugin_evm/utils/i18n/index.dart';
import 'package:polkawallet_sdk/plugin/store/balances.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/tokenIcon.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/dialog.dart';
import 'package:polkawallet_ui/components/v3/index.dart' as v3;
import 'package:polkawallet_ui/pages/scanPage.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:rive/src/widgets/rive_animation.dart';

class ManageAssetsPage extends StatefulWidget {
  ManageAssetsPage(this.plugin);

  PluginEvm plugin;

  static const String route = 'evm/assets/manage';

  @override
  _ManageAssetsPageState createState() => _ManageAssetsPageState();
}

class _ManageAssetsPageState extends State<ManageAssetsPage> {
  final TextEditingController _filterCtrl = new TextEditingController();

  bool _hide0 = false;
  String _filter = '';
  Map<String, bool> _tokenVisible = {};

  Timer? _delayTimer;
  bool _isLoading = false;

  List<TokenBalanceData> _seachBalance = [];

  bool hasFocus = false;
  bool isSeach = false;

  FocusNode _focusNode = FocusNode();

  Future<void> _onSave() async {
    final config = Map<String, bool>.of(_tokenVisible);
    if (_hide0) {
      for (var e in widget.plugin.noneNativeTokensAll) {
        if (Fmt.balanceInt(e.amount) == BigInt.zero) {
          config[e.id!.toLowerCase()] = false;
        }
      }
    }

    widget.plugin.store?.assets.setCustomAssets(
        widget.plugin.service!.keyring.current.toKeyPairData(),
        widget.plugin.basic.name!,
        config);

    final dic = I18n.of(context)!.getDic(i18n_full_dic_evm, 'assets')!;
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return PolkawalletAlertDialog(
          title: Text('${dic['manage.save']} ${dic['manage.save.ok']}'),
          actions: [
            PolkawalletActionSheetAction(
              child: Text(
                  I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!['ok']!),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        );
      },
    );

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nativeToken = widget.plugin.nativeToken.toLowerCase();
      final Map<String, bool> defaultVisibleMap = {nativeToken: true};

      if (widget.plugin.store!.assets.customAssets.keys.isEmpty) {
        // final defaultList = widget.plugin.defaultTokens.toList();
        // defaultList.forEach((token) {
        //   defaultVisibleMap[token] = true;
        // });

        for (var token in widget.plugin.noneNativeTokensAll) {
          if (defaultVisibleMap[token.id!.toLowerCase()] == null) {
            defaultVisibleMap[token.id!.toLowerCase()] = false;
          }
        }
      } else {
        for (var token in widget.plugin.noneNativeTokensAll) {
          defaultVisibleMap[token.id!.toLowerCase()] = widget
                  .plugin.store!.assets.customAssets[token.id!.toLowerCase()] ??
              false;
        }
      }

      setState(() {
        _tokenVisible = defaultVisibleMap;
      });
    });
  }

  @override
  void dispose() {
    _filterCtrl.dispose();

    super.dispose();
  }

  Future<void> _onInputChange(String input) async {
    setState(() {
      _seachBalance = [];
    });
    if (Fmt.isAddressETH(input.trim()) &&
        widget.plugin.noneNativeTokensAll.indexWhere((element) =>
                element.id!.toLowerCase() == input.trim().toLowerCase()) <
            0) {
      if (_delayTimer != null) {
        _delayTimer!.cancel();
      }
      _delayTimer = Timer(const Duration(milliseconds: 500), () async {
        try {
          setState(() {
            _isLoading = true;
          });
          final tokenBalance = await widget.plugin.sdk.api.eth.account
              .getTokenBalance(widget.plugin.service!.keyring.current.address!,
                  [input.trim()]);
          setState(() {
            _isLoading = false;
            _seachBalance = (tokenBalance ?? [])
                .map((e) => TokenBalanceData(
                      id: e['contractAddress'],
                      tokenNameId: e['contractAddress'],
                      symbol: e['symbol'],
                      name: e['symbol'] == widget.plugin.nativeToken
                          ? "W${e['symbol']}"
                          : e['symbol'],
                      fullName: e['name'],
                      decimals: e['decimals'],
                      amount: e['amount'],
                      detailPageRoute: ethTokenDetailPageRoute,
                    ))
                .toList();
          });
        } catch (_) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }

    setState(() {
      _filter = _filterCtrl.text.trim().toLowerCase();
    });
  }

  Widget _buildSeach() {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_evm, 'assets')!;
    final List<TokenBalanceData> list = [];
    if (_filterCtrl.text.trim().isNotEmpty) {
      list.add(TokenBalanceData(
          amount: widget.plugin.balances.native?.freeBalance?.toString() ?? "",
          decimals: 18,
          id: widget.plugin.nativeToken.toUpperCase(),
          symbol: widget.plugin.nativeToken.toUpperCase(),
          name: widget.plugin.nativeToken.toUpperCase(),
          fullName: '${widget.plugin.basic.name} ${dic['manage.native']}'));
      list.addAll(widget.plugin.noneNativeTokensAll);

      list.retainWhere((token) =>
          token.symbol!.toLowerCase().contains(_filter.toLowerCase()) ||
          (token.name ?? '').toLowerCase().contains(_filter.toLowerCase()) ||
          (token.id ?? '').toLowerCase().contains(_filter.toLowerCase()));

      for (var e in _seachBalance) {
        if (list.indexWhere(
                (element) => element.id!.toLowerCase() == e.id!.toLowerCase()) <
            0) {
          list.add(e);
        }
      }
    }
    return _tokensList(list);
  }

  Widget _tokensList(List<TokenBalanceData> list) {
    return Container(
        color: UI.isDarkTheme(context)
            ? const Color(0xFF3D3D3D)
            : Colors.transparent,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final isImport = widget.plugin.noneNativeTokensAll.indexWhere(
                        (element) =>
                            element.id!.toLowerCase() ==
                            list[i].id!.toLowerCase()) >=
                    0 ||
                list[i].id!.toUpperCase() ==
                    widget.plugin.nativeToken.toUpperCase();
            return Column(
              children: [
                Container(
                  color: Colors.transparent,
                  child: ListTile(
                    dense: list[i].fullName != null,
                    leading: TokenIcon(
                      list[i].id!,
                      widget.plugin.tokenIcons,
                      symbol: list[i].id,
                    ),
                    title: Text(list[i].name!,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    subtitle: list[i].fullName != null
                        ? Text('${list[i].fullName}',
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: UI.getTextSize(10, context),
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color,
                                fontFamily:
                                    UI.getFontFamily('SF_Pro', context)))
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 18.w),
                            child: Text(
                              Fmt.priceFloorBigInt(
                                  Fmt.balanceInt(list[i].amount),
                                  list[i].decimals!,
                                  lengthMax: 4),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.6),
                            )),
                        Image.asset(
                          "assets/images/${(_tokenVisible[list[i].id!.toLowerCase()] ?? false) ? "icon_circle_select${UI.isDarkTheme(context) ? "_dark" : ""}.png" : isImport ? "icon_circle_unselect${UI.isDarkTheme(context) ? "_dark" : ""}.png" : "import.png"}",
                          fit: BoxFit.contain,
                          width: 16.w,
                        )
                      ],
                    ),
                    onTap: () {
                      if (list[i].id != widget.plugin.nativeToken) {
                        if (!isImport) {
                          //add to noneNativeTokensAll
                          widget.plugin.store!.assets.setTokenBalanceMap(
                              widget.plugin.noneNativeTokensAll..add(list[i]),
                              widget.plugin.service!.keyring.current.address);
                        }
                        setState(() {
                          _tokenVisible[list[i].id!.toLowerCase()] =
                              !(_tokenVisible[list[i].id!.toLowerCase()] ??
                                  false);
                        });
                      }
                    },
                  ),
                ),
                const Divider(
                  height: 1,
                )
              ],
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_evm, 'assets')!;

    // final isStateMint =
    //     widget.service.plugin.basic.name == para_chain_name_statemine ||
    //         widget.service.plugin.basic.name == para_chain_name_statemint;

    final List<TokenBalanceData> list = [
      TokenBalanceData(
          amount: widget.plugin.balances.native?.freeBalance?.toString() ?? "",
          decimals: 18,
          id: widget.plugin.nativeToken.toUpperCase(),
          symbol: widget.plugin.nativeToken.toUpperCase(),
          name: widget.plugin.nativeToken.toUpperCase(),
          fullName: '${widget.plugin.basic.name} ${dic['manage.native']}')
    ];
    list.addAll(widget.plugin.noneNativeTokensAll);

    // list.retainWhere((token) =>
    //     token.symbol!.toUpperCase().contains(_filter) ||
    //     (token.name ?? '').toUpperCase().contains(_filter) ||
    //     (token.id ?? '').toUpperCase().contains(_filter));

    if (_hide0) {
      list.removeWhere((token) => Fmt.balanceInt(token.amount) == BigInt.zero);
    }

    // if (hasFocus) {
    //   _seachBalance.forEach((e) {
    //     if (list.indexWhere((element) => element.id == e.id) < 0) {
    //       list.add(e);
    //     }
    //   });
    // }

    return WillPopScope(
        onWillPop: () {
          if (isSeach) {
            setState(() {
              isSeach = false;
              _filterCtrl.text = "";
              _seachBalance = [];
              _filter = "";
            });
            FocusScope.of(context).requestFocus(FocusNode());
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text(dic['manage']!),
              centerTitle: true,
              elevation: 1.5,
              actions: [
                GestureDetector(
                    onTap: _onSave,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15.h, 0, 15.h, 4),
                      margin: EdgeInsets.only(right: 14.w),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                            image: AssetImage("assets/images/icon_bg.png"),
                            fit: BoxFit.contain),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        dic['manage.save']!,
                        style: TextStyle(
                          color: UI.isDarkTheme(context)
                              ? Theme.of(context).textTheme.headline5?.color
                              : Theme.of(context).cardColor,
                          fontSize: UI.getTextSize(12, context),
                          fontFamily: UI.getFontFamily('TitilliumWeb', context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
              ],
              leading: BackBtn(
                onBack: () {
                  if (isSeach) {
                    setState(() {
                      isSeach = false;
                      _filterCtrl.text = "";
                      _seachBalance = [];
                      _filter = "";
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              )),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                    child: Focus(
                        onFocusChange: (hasFocus) async {
                          setState(() {
                            this.hasFocus = hasFocus;
                            isSeach = hasFocus;
                            if (!isSeach) {
                              _filterCtrl.text = "";
                              _seachBalance = [];
                              _filter = "";
                            }
                          });
                        },
                        child: v3.TextInputWidget(
                          decoration: v3.InputDecorationV3(
                            contentPadding: EdgeInsets.zero,
                            hintText: dic['manage.filter'],
                            hintStyle: Theme.of(context).textTheme.headline4,
                            icon: _isLoading
                                ? Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    width: 14,
                                    height: 14,
                                    child: const RiveAnimation.asset(
                                      'assets/images/loading.riv',
                                      fit: BoxFit.none,
                                    ),
                                  )
                                : Icon(
                                    Icons.search,
                                    color: Theme.of(context).disabledColor,
                                    size: 20,
                                  ),
                            suffixIcon: GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 12.w, top: 10, bottom: 10),
                                child: SvgPicture.asset(
                                    'assets/images/scan.svg',
                                    color: Theme.of(context).disabledColor),
                              ),
                              onTap: () async {
                                final to = await Navigator.of(context)
                                    .pushNamed(ScanPage.route);
                                if (to != null) {
                                  setState(() {
                                    _filterCtrl.text =
                                        (to as QRCodeResult).address?.address ??
                                            "";
                                    isSeach = true;
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode);
                                  });
                                  _onInputChange(_filterCtrl.text);
                                }
                              },
                            ),
                          ),
                          focusNode: _focusNode,
                          controller: _filterCtrl,
                          style: Theme.of(context).textTheme.headline4,
                          onChanged: _onInputChange,
                        ))),
                Expanded(
                    child: isSeach
                        ? _buildSeach()
                        : Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: _hide0
                                                ? Theme.of(context)
                                                    .toggleableActiveColor
                                                : Theme.of(context)
                                                    .disabledColor,
                                            size: 14,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 4, right: 16),
                                            child: Text(
                                              dic['manage.hide']!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                      fontFamily:
                                                          UI.getFontFamily(
                                                              'SF_Pro',
                                                              context),
                                                      color: _hide0
                                                          ? Theme.of(context)
                                                              .toggleableActiveColor
                                                          : Theme.of(context)
                                                              .disabledColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _hide0 = !_hide0;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: _tokenVisible.keys.isEmpty
                                    ? const Center(
                                        child: CupertinoActivityIndicator(
                                            color: Color(0xFF3C3C44)))
                                    : _tokensList(list),
                              ),
                            ],
                          )),
              ],
            ),
          ),
        ));
  }
}
