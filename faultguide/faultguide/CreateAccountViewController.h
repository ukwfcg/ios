//
//  CreateAccountViewController.h
//  faultguide
//
//  Created by Sudeep Talati on 30/01/2013.
//  Copyright (c) 2013 UK Whitegoods. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *creatAccountButton;
 

@property (strong, nonatomic) IBOutlet UILabel *secondHeading;

@property(nonatomic, readonly, getter=isEditing) BOOL editing;
 
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@property (strong, nonatomic) IBOutlet UITextField *loginEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *loginPasswordTextField;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)registerAccountAction:(id)sender;
- (IBAction)loginAction:(id)sender;

@end
