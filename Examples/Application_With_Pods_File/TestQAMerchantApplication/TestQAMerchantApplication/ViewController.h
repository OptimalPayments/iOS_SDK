//
//  ViewController.h
//  TestQAMerchantApplication
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *homePayBtn;
@property (nonatomic, retain) IBOutlet UIButton *phonePayBtn;
@property (nonatomic, retain) HomeViewController *homeController;

-(IBAction)homeBtnSelected:(id)sender;

-(IBAction)backPressed:(UIStoryboardSegue *)seque;


@end

