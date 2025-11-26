import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';

class AppSvgWidget extends StatelessWidget {
  final String? assetsName;
  final String? networkName;
  final BoxFit boxFit;
  final double? height;
  final double? width;
  final Color? color;
  final AlignmentGeometry alignment;

  const AppSvgWidget({
    super.key,
    this.assetsName,
    this.networkName = '',
    this.boxFit = BoxFit.contain,
    this.height,
    this.width,
    this.alignment = Alignment.center,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (!networkName.isNullOrEmpty()) {
      return SvgPicture.network(
        networkName!,
        alignment: alignment,
        fit: boxFit,
        height: height,
        width: width,
        color: color,
      );
    }

    return (assetsName.isNullOrEmpty())
        ? SvgPicture.asset(
            AppAssets.infoOutline,
            alignment: alignment,
            fit: boxFit,
            height: height,
            width: width,
            color: color,
          )
        : SvgPicture.asset(
            assetsName!,
            alignment: alignment,
            fit: boxFit,
            height: height,
            width: width,
            color: color,
          );
  }
}
