#import "CoreCardIoPlugin.h"
#import "CardIO.h"

@interface CoreCardIoPlugin ()<CardIOPaymentViewControllerDelegate>
@end

@implementation CoreCardIoPlugin {
    FlutterResult _result;
    NSDictionary *_arguments;
    CardIOPaymentViewController *_scanViewController;
    UIViewController *_viewController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"core_card_io_beta"
                                     binaryMessenger:[registrar messenger]];
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    CoreCardIoPlugin *instance = [[CoreCardIoPlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (_result) {
        _result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
        _result = nil;
    }
    
    if ([@"scanCard" isEqualToString:call.method]) {
        _scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
        _scanViewController.delegate = self;
        
        _result = result;
        _arguments = call.arguments;
        
        _scanViewController.scanExpiry = [_arguments objectForKey:@"scanExpiry"] && [_arguments objectForKey:@"scanExpiry"] != (id)[NSNull null] ? [[_arguments objectForKey:@"scanExpiry"] boolValue] : false;
        _scanViewController.collectExpiry = [_arguments objectForKey:@"requireExpiry"] && [_arguments objectForKey:@"requireExpiry"] != (id)[NSNull null] ? [[_arguments objectForKey:@"requireExpiry"] boolValue] : false;
        _scanViewController.collectCVV = [_arguments objectForKey:@"requireCVV"] && [_arguments objectForKey:@"requireCVV"] != (id)[NSNull null] ? [[_arguments objectForKey:@"requireCVV"] boolValue] : false;
        _scanViewController.collectPostalCode = [_arguments objectForKey:@"requirePostalCode"] && [_arguments objectForKey:@"requirePostalCode"] != (id)[NSNull null] ? [[_arguments objectForKey:@"requirePostalCode"] boolValue] : false;
        _scanViewController.collectCardholderName = [_arguments objectForKey:@"requireCardHolderName"] && [_arguments objectForKey:@"requireCardHolderName"] != (id)[NSNull null] ? [[_arguments objectForKey:@"requireCardHolderName"] boolValue] : false;
        _scanViewController.restrictPostalCodeToNumericOnly = [_arguments objectForKey:@"restrictPostalCodeToNumericOnly"] && [_arguments objectForKey:@"restrictPostalCodeToNumericOnly"] != (id)[NSNull null] ? [[_arguments objectForKey:@"restrictPostalCodeToNumericOnly"] boolValue] : false;
      _scanViewController.scanInstructions = [_arguments objectForKey:@"scanInstructions"] != (id)[NSNull null] ? [_arguments valueForKey:@"scanInstructions"] : @"";
        _scanViewController.keepStatusBarStyle = [_arguments objectForKey:@"keepApplicationTheme"] && [_arguments objectForKey:@"keepApplicationTheme"] != (id)[NSNull null] ? [[_arguments objectForKey:@"keepApplicationTheme"] boolValue] : false;
        _scanViewController.hideCardIOLogo = [_arguments objectForKey:@"hideCardIOLogo"] && [_arguments objectForKey:@"hideCardIOLogo"] != (id)[NSNull null] ? [[_arguments objectForKey:@"hideCardIOLogo"] boolValue] : false;
        _scanViewController.useCardIOLogo = [_arguments objectForKey:@"useCardIOLogo"] && [_arguments objectForKey:@"useCardIOLogo"] != (id)[NSNull null] ? [[_arguments objectForKey:@"useCardIOLogo"] boolValue] : false;
        _scanViewController.suppressScanConfirmation = [_arguments objectForKey:@"suppressConfirmation"] && [_arguments objectForKey:@"suppressConfirmation"] != (id)[NSNull null] ? [[_arguments objectForKey:@"suppressConfirmation"] boolValue] : false;
        _scanViewController.disableManualEntryButtons = [_arguments objectForKey:@"suppressManualEntry"] && [_arguments objectForKey:@"suppressManualEntry"] != (id)[NSNull null] ? [[_arguments objectForKey:@"suppressManualEntry"] boolValue] : false;
        _scanViewController.languageOrLocale = [_arguments objectForKey:@"languageOrLocale"] != (id)[NSNull null] ? [_arguments valueForKey:@"languageOrLocale"] : @"";
        
        [_viewController presentViewController:_scanViewController animated:YES completion:nil];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [_scanViewController dismissViewControllerAnimated:YES completion:nil];
    _scanViewController = nil;
    _result([NSNull null]);
    _result = nil;
    _arguments = nil;
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSString *cardType = @"unknown";
    if(info.cardType != CardIOCreditCardTypeUnrecognized && info.cardType != CardIOCreditCardTypeAmbiguous) {
        switch (info.cardType) {
            case CardIOCreditCardTypeAmex:
                cardType = @"amex";
                break;
            case CardIOCreditCardTypeJCB:
                cardType = @"jcb";
                break;
            case CardIOCreditCardTypeVisa:
                cardType = @"visa";
                break;
            case CardIOCreditCardTypeMastercard:
                cardType = @"masterCard";
                break;
            case CardIOCreditCardTypeDiscover:
                cardType = @"discover";
                break;
            default:
                break;
        }
    }
    _result(@{
        @"cardholderName": ObjectOrNull(info.cardholderName),
        @"cardNumber": ObjectOrNull(info.cardNumber),
        @"cardType": ObjectOrNull(cardType),
        @"redactedCardNumber": ObjectOrNull(info.redactedCardNumber),
        @"expiryMonth": ObjectOrNull(@(info.expiryMonth)),
        @"expiryYear": ObjectOrNull(@(info.expiryYear)),
        @"cvv": ObjectOrNull(info.cvv),
        @"postalCode": ObjectOrNull(info.postalCode)
    });
    [_scanViewController dismissViewControllerAnimated:YES completion:nil];
    _scanViewController = nil;
    _result = nil;
    _arguments = nil;
}

static id ObjectOrNull(id object) {
    return object ?: [NSNull null];
}

@end
