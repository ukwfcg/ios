//
//  ManageAccountViewController.h
//  faultguide
//
//  Created by Sudeep Talati on 21/02/2013.
//  Copyright (c) 2013 UK Whitegoods. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageAccountViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *loginLbl;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UILabel *passwordlabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *confirmPasswordLabel;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *restoreSubmitBtn;
@property (strong, nonatomic) IBOutlet UIButton *registerSubmitBtn;
@property (strong, nonatomic) IBOutlet UILabel *helpLabel;
 



- (IBAction)registerBtnClick:(id)sender;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction)restoreSubmitAction:(id)sender;
- (IBAction)registerSubmitAction:(id)sender;

@end
