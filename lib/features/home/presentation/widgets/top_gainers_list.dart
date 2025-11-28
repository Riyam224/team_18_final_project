import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/features/home/domain/entities/top_gainer.dart';
import 'package:team_18_final_project/features/home/presentation/widgets/top_gainer_tile.dart';

class TopGainersList extends StatelessWidget {
  final List<TopGainerEntity> topGainers;

  const TopGainersList({super.key, required this.topGainers});

  String _formatPrice(double price) {
    if (price >= 1) {
      return "\$${price.toStringAsFixed(2)}";
    } else {
      return "\$${price.toStringAsFixed(6)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (topGainers.isEmpty) {
      return const Center(
        child: Text(AppStrings.noTopGainersAvailable),
      );
    }

    return Column(
      children: topGainers.asMap().entries.map((entry) {
        final index = entry.key;
        final gainer = entry.value;

        return Column(
          children: [
            if (index > 0) AppSpacing.gapH12,
            TopGainerTile(
              name: gainer.name,
              symbol: gainer.symbol,
              price: _formatPrice(gainer.currentPrice),
              percentage:
                  "${gainer.priceChangePercentage24h >= 0 ? '+' : ''}${gainer.priceChangePercentage24h.toStringAsFixed(2)}%",
              imageUrl: gainer.imageUrl,
            ),
          ],
        );
      }).toList(),
    );
  }
}
