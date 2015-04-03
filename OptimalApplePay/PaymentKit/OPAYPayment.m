//
//  OPAYPayment.m
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import "OPAYPayment.h"
#import "OPAYApplePayDef.h"

@interface OPAYPayment ()

@end

@implementation OPAYPayment

+ (BOOL)canSubmitPaymentRequest:(PKPaymentRequest *)paymentRequest {
    if (paymentRequest == nil) {
        return NO;
    }
    return [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:paymentRequest.supportedNetworks];
}

+ (PKPaymentRequest *)paymentRequestWithMerchantIdentifier:(NSString *)merchantIdentifier {
    if (![PKPaymentRequest class]) {
        return nil;
    }
    PKPaymentRequest *paymentRequest = [PKPaymentRequest new];
    [paymentRequest setMerchantIdentifier:merchantIdentifier];
    [paymentRequest setSupportedNetworks:@[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]];
    [paymentRequest setMerchantCapabilities:PKMerchantCapability3DS];
    [paymentRequest setCountryCode:OPAYApplePayDef.countryCode];
    [paymentRequest setCurrencyCode:OPAYApplePayDef.currencyCode];
    return paymentRequest;
}
@end
