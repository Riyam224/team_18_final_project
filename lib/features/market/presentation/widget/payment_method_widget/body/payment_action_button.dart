import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_action_button.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/screens/payment_screen.dart';
import 'package:team_18_final_project/features/transactions/domain/entities/transaction_record.dart';
import 'package:team_18_final_project/features/transactions/domain/usecases/add_transaction_usecase.dart';

class PaymentActionButton extends StatefulWidget {
  final PaymentData paymentData;

  const PaymentActionButton({
    super.key,
    required this.paymentData,
  });

  @override
  State<PaymentActionButton> createState() => _PaymentActionButtonState();
}

class _PaymentActionButtonState extends State<PaymentActionButton> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Create transaction record
      final transaction = TransactionRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'buy',
        amount: widget.paymentData.cryptoAmount,
        asset: widget.paymentData.coinSymbol,
        timestamp: DateTime.now(),
        note:
            'Bought ${widget.paymentData.cryptoAmount.toStringAsFixed(4)} ${widget.paymentData.coinSymbol} for \$${widget.paymentData.totalAmount.toStringAsFixed(2)}',
      );

      // Add transaction using the use case
      final addTransactionUseCase = sl<AddTransactionUseCase>();
      await addTransactionUseCase(transaction);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully purchased ${widget.paymentData.cryptoAmount.toStringAsFixed(4)} ${widget.paymentData.coinSymbol}!',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to home after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.go(AppRoutes.home);
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: AppSpacing.paddingL16R16B23,
      child: BottomActionButton.text(
        backgroundColor: _isProcessing
            ? Colors.grey
            : (isDark ? AppColors.lightSurface : AppColors.primary),
        height: 52.h,
        borderRadiusGeometry: BorderRadius.circular(31).r,
        onPressed: _isProcessing ? null : _processPayment,
        text: _isProcessing ? 'Processing...' : AppStrings.buy,
        fontSize: 16.sp,
        textColor: isDark ? AppColors.textDark : AppColors.textWhite,
      ),
    );
  }
}
