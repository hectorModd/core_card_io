
library core_card_io_beta;

import 'dart:async';
import 'dart:convert';

import 'package:dataclass_beta/dataclass_beta.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'core_card_io_beta.g.dart';

class CoreCardIo {
  static const MethodChannel _channel = const MethodChannel('core_card_io_beta');

  static Future<CoreCardIoResponse?> scanCard({
    bool? requireExpiry,
    bool? scanExpiry,
    bool? requireCVV,
    bool? requirePostalCode,
    bool? requireCardHolderName,
    bool? restrictPostalCodeToNumericOnly,
    bool? suppressManualEntry,
    bool? suppressConfirmation,
    bool? hideCardIOLogo,
    bool? useCardIOLogo,
    bool? usePayPalActionbarIcon,
    bool? keepApplicationTheme,
    String? scanInstructions,
    String? languageOrLocale
  }) async {
    final Map<dynamic, dynamic>? result = (await _channel.invokeMethod('scanCard', {
      'requireExpiry': requireExpiry,
      'scanExpiry': scanExpiry,
      'requireCVV': requireCVV,
      'requirePostalCode': requirePostalCode,
      'requireCardHolderName': requireCardHolderName,
      'restrictPostalCodeToNumericOnly': restrictPostalCodeToNumericOnly,
      'suppressManualEntry': suppressManualEntry,
      'suppressConfirmation': suppressConfirmation,
      'hideCardIOLogo': hideCardIOLogo,
      'useCardIOLogo': useCardIOLogo,
      'usePayPalActionbarIcon': usePayPalActionbarIcon,
      'keepApplicationTheme': keepApplicationTheme,
      'scanInstructions': scanInstructions,
      'languageOrLocale': languageOrLocale
    }));

    return await compute<Map<String, dynamic>?, CoreCardIoResponse?>(
      CoreCardIoResponse.fromJson,
      result?.map((key, value) => MapEntry(key.toString(), value))
    );
  }
}

enum CoreCardIoCardType {
  unknown,
  amex,
  dinersClub,
  discover,
  jcb,
  masterCard,
  visa,
  maestro
}

@DataClass()
@JsonSerializable(createToJson: false)
class CoreCardIoResponse with _$CoreCardIoResponse {

  final CoreCardIoCardType cardType;
  final String? cardholderName;
  final String? cardNumber;
  final String? redactedCardNumber;
  final int? expiryMonth;
  final int? expiryYear;
  final String? cvv;
  final String? postalCode;

  CoreCardIoResponse({
    required this.cardType,
    this.cardholderName,
    this.cardNumber,
    this.redactedCardNumber,
    this.expiryMonth,
    this.expiryYear,
    this.cvv,
    this.postalCode
  });

  static CoreCardIoResponse? fromJson(Map<String, dynamic>? json) =>
      json != null? _$CoreCardIoResponseFromJson(json) : null;
}
