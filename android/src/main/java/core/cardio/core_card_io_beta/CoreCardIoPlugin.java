package core.cardio.core_card_io_beta;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;

import io.card.payment.CardIOActivity;
import io.card.payment.CardType;
import io.card.payment.CreditCard;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;

public class CoreCardIoPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, ActivityResultListener {
    private static final int MY_SCAN_REQUEST_CODE = 100;

    private Result pendingResult;
    private MethodCall methodCall;
    private MethodChannel channel;

    private ActivityPluginBinding activityBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "core_card_io_beta");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activityBinding = binding;
        activityBinding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activityBinding.removeActivityResultListener(this);
        activityBinding = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activityBinding = binding;
        activityBinding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        activityBinding.removeActivityResultListener(this);
        activityBinding = null;
    }

    @Override
    public void onMethodCall(@NotNull MethodCall call, @NotNull Result result) {
        if (pendingResult != null) {
            result.error("ALREADY_ACTIVE", "Scan card is already active", null);
            return;
        }

        Activity activity = activityBinding.getActivity();

        pendingResult = result;
        methodCall = call;

        if (call.method.equals("scanCard")) {
            Intent scanIntent = new Intent(activity, CardIOActivity.class);

            boolean requireExpiry = false;
            if (methodCall.hasArgument("requireExpiry") && methodCall.argument("requireExpiry") != null) {
                requireExpiry = methodCall.argument("requireExpiry");
            }

            boolean requireCVV = false;
            if (methodCall.hasArgument("requireCVV") && methodCall.argument("requireCVV") != null) {
                requireCVV = methodCall.argument("requireCVV");
            }

            boolean requirePostalCode = false;
            if (methodCall.hasArgument("requirePostalCode") && methodCall.argument("requirePostalCode") != null) {
                requirePostalCode = methodCall.argument("requirePostalCode");
            }

            boolean requireCardHolderName = false;
            if (methodCall.hasArgument("requireCardHolderName") && methodCall.argument("requireCardHolderName") != null) {
                requireCardHolderName = methodCall.argument("requireCardHolderName");
            }

            boolean restrictPostalCodeToNumericOnly = false;
            if (methodCall.hasArgument("restrictPostalCodeToNumericOnly") && methodCall.argument("restrictPostalCodeToNumericOnly") != null) {
                restrictPostalCodeToNumericOnly = methodCall.argument("restrictPostalCodeToNumericOnly");
            }

            boolean scanExpiry = false;
            if (methodCall.hasArgument("scanExpiry") && methodCall.argument("scanExpiry") != null) {
                scanExpiry = methodCall.argument("scanExpiry");
            }

            String scanInstructions = null;
            if (methodCall.hasArgument("scanInstructions") && methodCall.argument("scanInstructions") != null) {
                scanInstructions = methodCall.argument("scanInstructions");
            }

            boolean suppressManualEntry = false;
            if (methodCall.hasArgument("suppressManualEntry") && methodCall.argument("suppressManualEntry") != null) {
                suppressManualEntry = methodCall.argument("suppressManualEntry");
            }

            boolean suppressConfirmation = false;
            if (methodCall.hasArgument("suppressConfirmation") && methodCall.argument("suppressConfirmation") != null) {
                suppressConfirmation = methodCall.argument("suppressConfirmation");
            }

            boolean useCardIOLogo = false;
            if (methodCall.hasArgument("useCardIOLogo") && methodCall.argument("useCardIOLogo") != null) {
                useCardIOLogo = methodCall.argument("useCardIOLogo");
            }

            boolean hideCardIOLogo = false;
            if (methodCall.hasArgument("hideCardIOLogo") && methodCall.argument("hideCardIOLogo") != null) {
                hideCardIOLogo = methodCall.argument("hideCardIOLogo");
            }

            boolean usePayPalActionbarIcon = false;
            if (methodCall.hasArgument("usePayPalActionbarIcon") && methodCall.argument("usePayPalActionbarIcon") != null) {
                usePayPalActionbarIcon = methodCall.argument("usePayPalActionbarIcon");
            }

            boolean keepApplicationTheme = false;
            if (methodCall.hasArgument("keepApplicationTheme") && methodCall.argument("keepApplicationTheme") != null) {
                keepApplicationTheme = methodCall.argument("keepApplicationTheme");
            }

            String languageOrLocale = null;
            if (methodCall.hasArgument("languageOrLocale") && methodCall.argument("languageOrLocale") != null) {
                languageOrLocale = methodCall.argument("languageOrLocale");
            }

            // customize these values to suit your needs.
            scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_EXPIRY, requireExpiry); // default: false
            scanIntent.putExtra(CardIOActivity.EXTRA_SCAN_EXPIRY, scanExpiry);
            scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_CVV, requireCVV); // default: false
            scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_POSTAL_CODE, requirePostalCode); // default: false
            scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_CARDHOLDER_NAME, requireCardHolderName);
            scanIntent.putExtra(CardIOActivity.EXTRA_RESTRICT_POSTAL_CODE_TO_NUMERIC_ONLY, restrictPostalCodeToNumericOnly);
            scanIntent.putExtra(CardIOActivity.EXTRA_SCAN_INSTRUCTIONS, scanInstructions);
            scanIntent.putExtra(CardIOActivity.EXTRA_SUPPRESS_MANUAL_ENTRY, suppressManualEntry);
            scanIntent.putExtra(CardIOActivity.EXTRA_SUPPRESS_CONFIRMATION, suppressConfirmation);
            scanIntent.putExtra(CardIOActivity.EXTRA_USE_CARDIO_LOGO, useCardIOLogo);
            scanIntent.putExtra(CardIOActivity.EXTRA_HIDE_CARDIO_LOGO, hideCardIOLogo);
            scanIntent.putExtra(CardIOActivity.EXTRA_USE_PAYPAL_ACTIONBAR_ICON, usePayPalActionbarIcon);
            scanIntent.putExtra(CardIOActivity.EXTRA_KEEP_APPLICATION_THEME, keepApplicationTheme);
            scanIntent.putExtra(CardIOActivity.EXTRA_LANGUAGE_OR_LOCALE, languageOrLocale);

            // MY_SCAN_REQUEST_CODE is arbitrary and is only used within this activity.
            activity.startActivityForResult(scanIntent, MY_SCAN_REQUEST_CODE);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.d("onActivityResult", "code: " + requestCode);
        if (requestCode == MY_SCAN_REQUEST_CODE) {
            if (data != null && data.hasExtra(CardIOActivity.EXTRA_SCAN_RESULT)) {
                CreditCard scanResult = data.getParcelableExtra(CardIOActivity.EXTRA_SCAN_RESULT);

                Map<String, Object> response = new HashMap<>();
                response.put("cardholderName", scanResult.cardholderName);
                response.put("cardNumber", scanResult.cardNumber);
                String cardType = "unknown";
                if (scanResult.getCardType() != CardType.UNKNOWN && scanResult.getCardType() != CardType.INSUFFICIENT_DIGITS) {
                    switch (scanResult.getCardType()) {
                        case AMEX:
                            cardType = "amex";
                            break;
                        case DINERSCLUB:
                            cardType = "dinersClub";
                            break;
                        case DISCOVER:
                            cardType = "discover";
                            break;
                        case JCB:
                            cardType = "jcb";
                            break;
                        case MASTERCARD:
                            cardType = "masterCard";
                            break;
                        case VISA:
                            cardType = "visa";
                            break;
                        case MAESTRO:
                            cardType = "maestro";
                            break;
                        default:
                            break;
                    }
                }
                response.put("cardType", cardType);
                response.put("redactedCardNumber", scanResult.getRedactedCardNumber());
                response.put("expiryMonth", scanResult.expiryMonth);
                response.put("expiryYear", scanResult.expiryYear);
                response.put("cvv", scanResult.cvv);
                response.put("postalCode", scanResult.postalCode);
                pendingResult.success(response);
            } else {
                pendingResult.success(null);
            }
            pendingResult = null;
            methodCall = null;
            return true;
        }
        return false;
    }
}