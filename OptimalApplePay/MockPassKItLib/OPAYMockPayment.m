//
//  OPAYMockPayment.m
//
//  Created by sachin on 26/02/15.
//  Copyright (c) 2015 Optimalpayments. All rights reserved.
//

#import "OPAYMockPayment.h"
#import "OPAYMockApplePayDef.h"

@implementation OPAYMockPayment

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
    [paymentRequest setCountryCode:OPAYMockApplePayDef.countryCode];
    [paymentRequest setCurrencyCode:OPAYMockApplePayDef.currencyCode];
    return paymentRequest;
}


@end
