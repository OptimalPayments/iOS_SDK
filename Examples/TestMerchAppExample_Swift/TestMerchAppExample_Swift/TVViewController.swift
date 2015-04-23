//
//  TVViewController.swift
//  TestWSMerchantApplication-Swift
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 2/18/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

/*  Real SDK */

import Foundation

class TVViewController: UIViewController , OPAYPaymentAuthorizationProcessDelegate, UITextFieldDelegate, AuthorizationProcessDelegate {
    
    var OPTApplePaySDKObj : OPAYPaymentAuthorizationProcess? // = OPTPaymentAuthorizationProcess()
    @IBOutlet var payNowButton : UIButton?
    var isApplePaySupports : Bool?
    
    @IBOutlet var authrizationBtn : UIButton?
    @IBOutlet var purchaseSwitch: UISwitch?
    var isOn:Bool = false
    @IBOutlet var merchantRefField : UITextField?
    @IBOutlet var amountField : UITextField?
    
    var authorizationData: NSDictionary = NSDictionary()
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if(appDelegate.OPAYApplePaySDKObj?.isApplePaySupport() == false){
            payNowButton?.setImage(UIImage(named: "payNow_img"), forState: .Normal)
            isApplePaySupports = false
        }
        else{
            isApplePaySupports = true
        }
        
        authrizationBtn?.hidden = true
        
        self.merchantRefField?.delegate = self
        self.amountField?.delegate = self
        
    }
    
    @IBAction func tvPayNowSelected(sender:UIButton) {
        println("tvPayNowSelected")
        
        var amount: String! = amountField?.text
        if (amount == "" || amount == nil )
        {
             showAlertView("Alert", errorMessage: "Amount should not be empty or zero.")
            return;
        }
        
#if (arch(i386) || arch(x86_64)) && os(iOS)
    
    appDelegate.OPAYApplePaySDKObj?.authDelegate = self
    appDelegate.OPAYApplePaySDKObj?.beginPayment(self, withRequestData: createDataDictonary(), withCartData: createCartData())
    
#else
    
    if(appDelegate.OPAYApplePaySDKObj?.isApplePaySupport() == true)
    {
        appDelegate.OPAYApplePaySDKObj?.authDelegate = self
        appDelegate.OPAYApplePaySDKObj?.beginPayment(self, withRequestData: createDataDictonary(), withCartData: createCartData())
    }
    else
    {
        showAlertView("Alert", errorMessage: "Device does not support making Apple Pay payments!")
    }

#endif
        
    
}
    
    @IBAction func authorizeBtnSelected(sender:UIButton) {
        println("bagPayNowSelected")
        
        var authObj:OPTAuthorizationProcess = OPTAuthorizationProcess()
        authObj.processDelegate = self
        authObj.prepareRequestForAuthorization(createAuthDataDictonary())
        
    }
    
    
    func callBackResponseFromOPTSDK(response: [NSObject : AnyObject]!) {
        
        if (response != nil){
            if let nameObject: AnyObject = response["error"] {
                var errorCode: String = String()
                var errorMsg: String = String()
                if var errCode: AnyObject = nameObject["code"]{
                    if let nameString = errCode as? String {
                        errorCode = nameString
                    }
                }
                
                
                if var errCode: AnyObject = nameObject["message"]{
                    if let nameString = errCode as? String {
                        errorMsg = nameString
                    }
                }
                
                
                self .showAlertView(errorCode, errorMessage: errorMsg)
                
                
            }
            else{
                authorizationData = response
                
                
                authrizationBtn?.hidden = false
                
                
                var tokenData: AnyObject = response["paymentToken"]!
                self .showAlertView("Success", errorMessage: "Your payment token is ::\(tokenData)")
            }
        }else{
            self .showAlertView("Alert", errorMessage: "Error message")
        }
    }
    
    func callBackResponseFromOptimalRequest(response: [NSObject : AnyObject]!) {
        println("callBackResponseFromOptimalRequest")
        println(response)
        
        let jsonResult = response as? Dictionary<String, AnyObject>
        
    }
    
    func callBackAuthorizationProcess(dictonary: [NSObject : AnyObject]!) {
        var errorCode: String = String()
        var errorMsg: String = String()
        
        if(dictonary != nil)
        {
            if let nameObject: AnyObject = dictonary["error"] {
                if var errCode: AnyObject = nameObject["code"]{
                    if let nameString = errCode as? String {
                        errorCode = nameString
                    }
                }
                
                if var errCode: AnyObject = nameObject["message"]{
                    if let nameString = errCode as? String {
                        errorMsg = nameString
                    }
                }
                
            }else if let nameObject: AnyObject = dictonary["status"]{
                if var nameString = nameObject as? String {
                    if nameString == "COMPLETED"{
                        errorCode = nameString
                    }
                    if let nameObject: AnyObject = dictonary["settleWithAuth"]{
                        if var nameString = nameObject as? Int {
                            if nameString == 0{
                                errorMsg = "Authorization completed, please proceed for settlement."
                            }else{
                                errorMsg = "Settlement got completed, please check your order history."
                            }
                        }
                    }
                }
            }
            else{
                println(dictonary)
            }
            
            
            self .showAlertView(errorCode, errorMessage: errorMsg)
       
        }
    }
    
    
    func createDataDictonary() -> Dictionary<String, Dictionary <String,String>>{
        
        // Merchant shipping methods
        var shippingMethod1Dictionary: [String: String] = ["shippingName":"Llama California Shipping", "shippingAmount":"1.00", "shippingDes":"3-5 Business Days"]
        
        var envType:String = "TEST_ENV";  //PROD_ENV TEST_ENV
        
        var timeIntrval:String = "30.0";  //Time interval for connection to Optimal server
        
        
        var enviDictionary: [String: String] = ["EnvType":envType, "TimeIntrval":timeIntrval]
        
        var dataDictonary: [String: Dictionary] = ["ShippingMethod": shippingMethod1Dictionary,"EnvSettingDict": enviDictionary]
        
        return dataDictonary
    }
    
    
    func createCartData() -> Dictionary<String, String>{
        var amount: String! = amountField?.text
        var cartDictonary: [String: String] = ["CartID":"123423", "CartTitle":"TShirt", "CartCost":amount, "CartDiscount":"3", "CartShippingCost":"2","PayTo":"Sudheer"]
        
        return cartDictonary;
    }
    
    func createFakeTokenDataDictonary() -> Dictionary<String, String>{
        var dataDictonary: [String: String] = ["applicationPrimaryAccountNumber": "4111111111111111", "applicationExpirationDate":"181231" ,  "transactionAmount":"1499", "cardholderName":"Bill Gates"]
        
        return dataDictonary
    }
    
    func showAlertView(errorCode:String, errorMessage:String){
        var alert = UIAlertView(title: errorCode, message: errorMessage, delegate: self, cancelButtonTitle: "OK")
        alert .show()
        
    }
    
    @IBAction func isPurchase(sender:UISwitch){
        isOn = sender.on
        
        if(isOn){
            println("True")
        }else{
            println("False")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true);
        return false
    }
    
    func createAuthDataDictonary() -> Dictionary<String, AnyObject>{
        
        var tokenData: AnyObject = authorizationData["paymentToken"]!
        
        var description: String = "Hand bag - Big"
        
        var merchantRef: String! = merchantRefField?.text
        var merchantAmt: String! = amountField?.text
        
        
        var cardDictonary: [String: AnyObject] = ["paymentToken":tokenData]
        var authDictonary: [String: AnyObject] = ["merchantRefNum":merchantRef, "amount":merchantAmt, "card":cardDictonary, "description":description, "customerIp":[self .getIPAddress()], "settleWithAuth":isOn]
        return authDictonary;
    }
    
    
    func getIPAddress()->NSString{
        var ipAddress:NSString = ""
        
        let host = CFHostCreateWithName(nil,"www.google.com").takeRetainedValue();
        CFHostStartInfoResolution(host, .Addresses, nil);
        var success: Boolean = 0;
        let addresses = CFHostGetAddressing(host, &success).takeUnretainedValue() as NSArray;
        if (addresses.count > 0){
            let theAddress = addresses[0] as NSData;
            var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
            if getnameinfo(UnsafePointer(theAddress.bytes), socklen_t(theAddress.length),
                &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                    if let numAddress = String.fromCString(hostname) {
                        println(numAddress)
                        ipAddress = numAddress
                    }
            }
        }
        
        
        return ipAddress
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
}