import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/primary_appBar.dart';
import 'package:team_18_final_project/core/constants/theme_mode_color.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';

import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/widget/bitcoin_name_with_image.dart';
import 'package:team_18_final_project/features/market/presentation/widget/bitcoin_title_description.dart';
import 'package:team_18_final_project/features/market/presentation/widget/crypto_price_chart.dart';
import 'package:team_18_final_project/features/market/presentation/widget/market_stats_list.dart';
import 'package:team_18_final_project/features/market/presentation/widget/trade_bottom_bar.dart';

class CoinDetailsScreen extends StatelessWidget {
  final String coinId;

  const CoinDetailsScreen({
    super.key,
    required this.coinId,
  });

  @override
  Widget build(BuildContext context) {
    Color isDarkOrLight = ThemeModeColor.checkColorDarkOrLight(
      context,
      colorDark: AppColors.textWhite,
      colorLight: AppColors.primary,
    );
    return Scaffold(
      appBar: PrimaryAppBar(
        surfaceTintColor: Colors.transparent,
        leading: Icon(
          Icons.arrow_back_rounded,
          color: isDarkOrLight,
          size: 28,
        ),
        title: Text('Coin Details',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontSize: 23.sp, color: isDarkOrLight)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ).r,
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 29.h,
                ),
                const BitcoinNameWithImage(),
                SizedBox(
                  height: 14.91.h,
                ),
                const CryptoPriceChart(),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13).r,
                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Text("Statics",
                        style:
                            context.appTheme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: isDarkOrLight,
                        )),
                  ),
                ),
              ],
            ),
          ),
          MarketStatsList(),
          BitcoinTitleDescription()
        ]),
      ),
      bottomNavigationBar: TradeBottomBar(),
    );
  }
}
