//
//  OPAYPaymentAuthorizationProcess.h
//  OptimalApplePay
//
//  Created by sachin on 17/02/15.
//  Copyright (c) 2015 Optimalpayments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>



@protocol OPAYPaymentAuthorizationProcessDelegate<NSObject>

@required
/* This method will return the Customer vault Payment token
 to the app.
 Need to implment this method by declaring this delegate (where ever we are using this class).
 */
- (void)callBackResponseFromOPTSDK:(NSDictionary*)response;
/*
 This method will return response as below.
 1) Payment token from apple pay.
 {
 "version":"Value",
 "data":"Value",
 "signature":"Value",
 "header":
    {
    "ephemeralPublicKey":"Value",
    "transactionId":"Value",
    "publicKeyHash":"Value"
    }
 }
 
 2)Will get "Null" value while network problem.
 
 3) Optimal return the error response in below format,
 
 error =   
    {
    code = "Error code";
    links =
        (
        {
            href = "Reference link for the specied error.";
            rel = errorinfo;
        }
        );
    message = "Value";
        };
    }
 
 */
@end;

@interface OPAYPaymentAuthorizationProcess : NSObject <NSURLConnectionDelegate,PKPaymentAuthorizationViewControllerDelegate>

@property(nonatomic, assign)id<OPAYPaymentAuthorizationProcessDelegate>authDelegate;


- (id)initWithMerchantIdentifier:(NSString*)merchantIdentifier withMerchantID:(NSString*)optiMerchantID withMerchantPwd:(NSString*)optiMerchantPwd withMerchantCountry:(NSString*)merchantCountry withMerchantCurrency:(NSString*)merchantCurrency;

- (void)beginPayment:(UIViewController *)viewController withRequestData:(NSDictionary*)dataDictionary withCartData:(NSDictionary*)cartData;

/**************************
 Sample data for dictionary.
 1)dataDictionary it contains shipping and environmental data dictionary.
 shippingMethodName = value
 shippingMethodAmount=value
 shippingMethodDescription=value
 
 EnvType=Value
 TimeIntrval=value
 
 
 2)cartData dictionary contains cart details.
 CartID=value
 CartTitle=value
 CartCost=value
 CartDiscount=value
 CartShippingCost=value
 PayTo=value
 
 */




// Determines whether this app can supports apple pay or not.
// YES, if it the device with apple pay required configuration (> iOS 8.0).
// NO, if it the device OS < iOS 8.0 & also if it is simulator.
- (BOOL)isApplePaySupport;

// Determine whether device can make payments with apple pay
// Need to have valid/ verified card payment networks ( i.e Amex, Visa & MasterCard ) in passbook.
// YES, if the user is using one of the authorized (verified)card payment networks supported on the device.
// NO, if the user doesn't have valid/verified card payment networks.
//- (BOOL)canMakePayments;

@end