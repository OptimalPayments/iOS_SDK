//
//  OPAYPayment.h
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>

@class PKPaymentRequest;

@interface OPAYPayment : NSObject

+ (BOOL)canSubmitPaymentRequest:(PKPaymentRequest *)paymentRequest;

+ (PKPaymentRequest *)paymentRequestWithMerchantIdentifier:(NSString *)merchantIdentifier;



@end
