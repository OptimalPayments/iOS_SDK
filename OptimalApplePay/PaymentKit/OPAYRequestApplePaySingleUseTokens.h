//
//  OPAYRequestApplePaySingleUseTokens.h
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPAYApplePayPaymentTokenInfo.h"

@interface OPAYRequestApplePaySingleUseTokens : NSObject


@property(retain)OPAYApplePayPaymentTokenInfo *tokenInfo;

-(id)prepareRequestRealToken:(NSData*)tokenData;


@end
