import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/card_data/master_card_data.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/card_data/visa_card_data.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/card_shape/master_card_background.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/card_shape/visa_card_background.dart';
import 'package:team_18_final_project/features/market/presentation/widget/payment_method_widget/credit_card/credit_card_widget.dart';

bool isDark({required BuildContext context}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  return isDark;
}

abstract class CardType {
  Widget buildCardWidget({required BuildContext context});
}

class VisaCard implements CardType {
  @override
  Widget buildCardWidget({required BuildContext context}) {
    return CreditCardWidget(
      creditCardBackground: VisaCardBackground(
        creditCardContent: VisaCardData(),
      ),
      colorBegin: isDark(context: context)
          ? Color.fromARGB(255, 4, 39, 166)
          : Color.fromARGB(234, 2, 34, 151),
      colorEnd: Color(0xFF7919B4),
      onTap: () {},
    );
  }
}

class MasterCard implements CardType {
  @override
  Widget buildCardWidget({required BuildContext context}) {
    return CreditCardWidget(
      creditCardBackground: MasterCardBackground(
        creditCardContent: MasterCardData(),
      ),
      colorBegin: isDark(context: context)
          ? Color(0xFF2A2A2A)
          : Color.fromARGB(255, 187, 186, 186),
      colorEnd: Color(0xFF2A2A2A),
      onTap: () {},
    );
  }
}

class AppleCard implements CardType {
  @override
  Widget buildCardWidget({required BuildContext context}) {
    return CreditCardWidget(
      creditCardBackground: Transform.scale(
        scale: 1.1,
        child: Image.asset(
          AppAssets.appleCard,
        ),
      ),
      onTap: () {},
    );
  }
}

abstract class CreditCardSelector {
  CardType selectCardByIndex({required int index});
}

class CheckCreditCardState implements CreditCardSelector {
  CardType _cardType = VisaCard();

  bool _isCreditCardVisible = true;
  int _selectedCardIndex = 0;

  bool get getIsCreditCardVisible => _isCreditCardVisible;
  int get getSelectedCardIndex => _selectedCardIndex;
  CardType get getCardType => _cardType;

  @override
  CardType selectCardByIndex({required int index}) {
    if (index == 0) {
      _selectedCardIndex = index;
      _isCreditCardVisible = _isCreditCardVisible;
      _cardType = VisaCard();
    } else if (index == 1) {
      _selectedCardIndex = index;
      _isCreditCardVisible = _isCreditCardVisible;
      _cardType = MasterCard();
    } else if (index == 2) {
      _selectedCardIndex = index;
      _cardType = AppleCard();
    }
    return _cardType;
  }
}
