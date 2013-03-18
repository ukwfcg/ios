//
//  InAppViewController.h
//  faultguide
//
//  Created by Sudeep Talati on 27/02/2013.
//  Copyright (c) 2013 UK Whitegoods. All rights reserved.
//

#import <UIKit/UIKit.h>
    
#import <StoreKit/StoreKit.h>

@interface InAppViewController : UIViewController


- (IBAction)purchase:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UIButton *button30Days;
@property (strong, nonatomic) IBOutlet UILabel *expiryDateLabel;
- (IBAction)register_login_btn:(id)sender;

@end
