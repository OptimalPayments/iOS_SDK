//
//  CreditCardViewController.swift
//  TestMerchAppExample_Swift
//
//  Created by PLMAC-A1278-C1MLJUH1DTY3 on 6/8/15.
//  Copyright (c) 2015 opus. All rights reserved.
//

import Foundation
import UIKit


class SWCreditCardViewController :UIViewController ,UITextFieldDelegate,OPAYPaymentAuthorizationProcessDelegate
{
    @IBOutlet var  scrollView :UIScrollView!
    @IBOutlet var  txtCardNo:UITextField!
    @IBOutlet var  txtCvv:UITextField!
    @IBOutlet var  txtExpMonth:UITextField!
    @IBOutlet var  txtExpYear:UITextField!
    @IBOutlet var  txtNameOnCard:UITextField!
    @IBOutlet var  txtStreet1:UITextField!
    @IBOutlet var  txtStreet2:UITextField!
    @IBOutlet var  txtCity:UITextField!
    @IBOutlet var  txtCountry:UITextField!
    @IBOutlet var  txtState:UITextField!
    @IBOutlet var  txtZip:UITextField!
    
    @IBOutlet var  btnConfirm:UIButton!
    @IBOutlet var  btnCancel:UIButton!
    @IBOutlet var  btnBack:UIButton!
    
    var  amount:NSString!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        scrollView.contentSize = CGSize(width:320, height:1200)
        
        btnConfirm.layer.cornerRadius=10;
        btnCancel.layer.cornerRadius=10;
        
        self.txtCardNo!.delegate = self
        self.txtExpMonth!.delegate = self
        self.txtExpYear!.delegate = self
        self.txtNameOnCard!.delegate = self
        self.txtStreet1!.delegate = self
        self.txtStreet2!.delegate = self
        self.txtCity!.delegate = self
        self.txtCountry!.delegate = self
        self.txtState!.delegate = self
        self.txtZip!.delegate = self
        
    }
    
    func createDataDictionary() -> Dictionary <String , AnyObject>
    {
        var cardExpData: [String: String] = ["month":txtExpMonth.text, "year":txtExpYear.text]
        
        var cardBillingAddress: [String: String] = ["street":txtStreet1.text, "street2":txtStreet2.text,"city":txtCity.text,"country":txtCountry.text,"state":txtState.text,"zip":txtZip.text]
        
        var cardData:[String:AnyObject]=["cardNum":txtCardNo.text , "holderName":txtNameOnCard.text,"cardExpiry":cardExpData,"billingAddress":cardBillingAddress];
        
        var cardDataDetails:[String:AnyObject]=["card":cardData];
        
        
        return cardDataDetails
    }
    
    @IBAction func confirmBtnSelected(sender:UIButton)
    {
        
        var envType:String = "TEST_ENV";  //PROD_ENV TEST_ENV
        
        var timeIntrval:String = "30.0";  //Time interval for connection to Optimal server
        
        var enviDictionary: [String: String] = ["EnvType":envType, "TimeIntrval":timeIntrval]
        
        appDelegate.OPAYAuthController?.authDelegate=self
        
        
        if (appDelegate.OPAYAuthController?.respondsToSelector(Selector("beginNonApplePayment:withRequestData:withEnvSettingDict:")) != nil)
        {
            appDelegate.OPAYAuthController?.beginNonApplePayment(self, withRequestData: createDataDictionary(), withEnvSettingDict: enviDictionary)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false
    }
    
    // Delegate methods
    func callBackResponseFromOPTSDK(response: [NSObject : AnyObject]!)
    {
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
                
                var tokenData: AnyObject = response["paymentToken"]!
                self .showAlertView("Success", errorMessage: "Your payment token is ::\(tokenData)")
            }
        }else{
            self .showAlertView("Alert", errorMessage: "Error message")
        }
        
    }
    func callNonAppleFlowFromOPTSDK()
    {
        
    }
    func showAlertView(errorCode:String, errorMessage:String){
        var alert = UIAlertView(title: errorCode, message: errorMessage, delegate: self, cancelButtonTitle: "OK")
        alert .show()
        
    }
    
}