//
//  ViewController.m
//  TestQAMerchantApplication
//
//  Copyright (c) 2015 Opus. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize homePayBtn, phonePayBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view, typically from a nib.
}

/* ------------------- UI placement ----------------------------- */

-(void)placeUIData{
    
}

/* ------------------- Main screen data ------------------------- */

-(IBAction)homeBtnSelected:(id)sender{
    _homeController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    
    
    UIStoryboard *storyboard = self.storyboard;
    _homeController = [storyboard instantiateViewControllerWithIdentifier:@"HomeviewController"];
    [self presentViewController:_homeController animated:YES completion:nil];
    
}


/* ------------------- Back pressed ----------------------------- */

-(IBAction)backPressed:(UIStoryboardSegue *)seque{
    [self.navigationController popViewControllerAnimated:YES];
}

/* ------------------- Home purchase work ---------------------- */






/* ------------------- Phone purchase work --------------------- */



#pragma mark Real SDK calling


#pragma mark End 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
