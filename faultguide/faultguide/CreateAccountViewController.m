//
//  CreateAccountViewController.m
//  faultguide
//
//  Created by Sudeep Talati on 30/01/2013.
//  Copyright (c) 2013 UK Whitegoods. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "DbHelper.h" 

@interface CreateAccountViewController ()
@end

@implementation CreateAccountViewController

@synthesize headingLabel=_headingLabel;
@synthesize emailTextField=_emailTextField;
@synthesize passwordTextField=_passwordTextField;
@synthesize confirmPasswordTextField=_confirmPasswordTextField;
@synthesize creatAccountButton=_creatAccountButton;
@synthesize secondHeading=_secondHeading;

@synthesize loginButton=_loginButton;
@synthesize loginEmailTextField=_loginEmailTextField;
@synthesize loginPasswordTextField=_loginPasswordTextField;

@synthesize scrollView=_scrollView; 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setBackgroundColor: [UIColor whiteColor]];
    
    
    [self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.passwordTextField setSecureTextEntry:YES];
    [self.confirmPasswordTextField setSecureTextEntry:YES];
    
    
    
    NSString *email_frm_db=[DbHelper database].getRegisteredEmailFromDb;
    
    
    [self.loginEmailTextField setText:email_frm_db];
    [self.loginEmailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.loginPasswordTextField setSecureTextEntry:YES];
    [self.loginPasswordTextField setText:[DbHelper database].getRegisteredPasswordFromDb];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
   
 
    
    
 
    NSString *content=@"1. The registration in this app is optional. However you can restore your inapp purchases only if you are registered. \n \n 2. This registration email account is different from your itunes account and is managed seperately for your inappas.  \n \n 3. Once registered, the server will automatically updated each time you make a new inapp purchase. \n \n 4. Incase you have uninstalled the app or you want to restore the app on another device, kindly use the same login credentials and you should be able to restore it.";
  
    
    float contentMargin=20;
    float contentWidth=270;
    float drawingPosition= 425;
    CGSize contentSize=[ content sizeWithFont:[UIFont fontWithName:@"Arial" size:16.0]
                            constrainedToSize:CGSizeMake(contentWidth, 9999)
                                lineBreakMode:NSLineBreakByWordWrapping];
    
    
    
    CGRect contentLabelFrame = CGRectMake(contentMargin, drawingPosition-5, contentSize.width, contentSize.height);
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentLabelFrame];
    [contentLabel setText:content];
    [contentLabel setFont:[UIFont fontWithName:@"Arial" size:16.0]];
    [contentLabel setNumberOfLines:0];
    
    
     [self.scrollView addSubview:contentLabel];
    
    drawingPosition=drawingPosition+contentLabel.frame.size.height+20;
    
    
    
    
    
    
    CGSize scrollViewcontentSize=CGSizeMake(320,drawingPosition );
    [self.scrollView setContentSize:scrollViewcontentSize];
    [self.scrollView setScrollEnabled:YES];
    
 
    [self.scrollView scrollRectToVisible:self.loginEmailTextField.frame animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 



-(void)dismissKeyboard
{
    UITextField *activeTextField = nil;
    if ([self.emailTextField isEditing]) activeTextField = self.emailTextField;
    else if ([self.passwordTextField isEditing]) activeTextField = self.passwordTextField;
    else if ([self.confirmPasswordTextField isEditing]) activeTextField = self.confirmPasswordTextField;
    else if ([self.loginEmailTextField isEditing]) activeTextField = self.loginEmailTextField;
    else if ([self.loginPasswordTextField isEditing]) activeTextField = self.confirmPasswordTextField;
    if (activeTextField) [activeTextField resignFirstResponder];
}


-(void) displayResposne:(NSData*)JSONData
{

    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:JSONData //1
                          options:kNilOptions
                          error:&error];
    
    NSString *rawStatus=[json objectForKey:@"status"];
    NSString *server_msg=[json objectForKey:@"message"];
    
    NSLog(@"THE SERVER STATUS:%@",rawStatus);
    NSLog(@"THE SERVER Message:%@",server_msg);
    
    int status= [rawStatus intValue];
    NSLog(@"INT STATUS in Cross Check Recipet %d",status);
    //[rawStatus release];rawStatus=nil;
    
 
    
    if (status == 200){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:server_msg
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        [alert show];
    }
    if (status == 500){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error"
                                                        message:server_msg
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        [alert show];
    }
    if (status == 204){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                        message:server_msg
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        [alert show];
    }
    if (status == 403){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forbidden"
                                                        message:server_msg
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    
    
}


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

 

 
- (IBAction)registerAccountAction:(id)sender {
    
    
    NSString *email=self.emailTextField.text;
    NSLog(@"Email Entered is %@",email);
    
    NSString *pass=self.passwordTextField.text;
    NSLog(@"Pass Entered is %@",pass);
    
    
    NSString *confirmPass=self.confirmPasswordTextField.text;
    NSLog(@"Confirm  Entered is %@",confirmPass);
        
    NSString *expiry_date=[DbHelper database].getFullVersionExpiryDate;
    NSLog(@"Expiry Date Entered is %@",expiry_date);
    
    
    
    
    
    
    
    BOOL validEmail=[self NSStringIsValidEmail:email];
    
    if (validEmail!=YES)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                        message:@"Please Enter a Valid Email Address. The email address is invalid"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
    
    if ([pass isEqualToString:confirmPass] && validEmail==YES)
    {
        NSLog(@"Registering the account");
        [self dismissKeyboard];
        
        [self.creatAccountButton setHighlighted:YES ];
        
        
        NSString *url= [NSString stringWithFormat:@"http://www.funkycool.co.uk/faultguide/register.php?email=%@&pass=%@&product_name=com.ukwhitegoods.faultguide.nonrenew01month&expiry_date=%@&no_of_times_downloaded=1",email,pass,expiry_date];
        

        /*
        NSString *url= [NSString stringWithFormat:@"http://www.funkycool.co.uk/faultguide/register.php?email=ty@gn.com&pass=pp&product_name=com.ukwhitegoods.faultguide.nonrenew01month&purchase_date=2012-01-31&expiry_date=2013-03-01"];
        */
        
        /*
         NSString *url= [NSString stringWithFormat:@"http://www.funkycool.co.uk/faultguide/register.php?email=sudeep.talati@gmail.com&pass=123445&product_name=com.ukwhitegoods.faultguide.nonrenew01month&purchase_date=200-10-12&expiry_date=25-10-1201"];
        */
         
         
        NSLog(@"THE URL is  %@",url);
        NSURL *requestURL = [NSURL URLWithString:url];
        NSData *JSONData = [[NSData alloc] initWithContentsOfURL:requestURL];
        NSLog(@"No of records %d",[JSONData length]);
        if ([JSONData length]>0)
        {
            NSString *response = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
            NSLog(@"The response is %@",response);
            [self displayResposne:JSONData];
            
            
            if([[DbHelper database]setRegistrationDetails:email password:pass])
            {
                NSLog(@"Registration details are set in Databse");
            }
        
        }
        
        
        
    
    }else
    {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password not matching"
                                                            message:@"The password you have entered does not macthes with each other. Please check the details"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil];
            
           [alert show];

    

    }
    
    
    
    
    
    
}

- (IBAction)loginAction:(id)sender {
    
    
    NSString *email=self.loginEmailTextField.text;
    NSLog(@"Email Entered is %@",email);
    
    NSString *pass=self.loginPasswordTextField.text;
    NSLog(@"Email Entered is %@",pass);
    
    
    BOOL validEmail=[self NSStringIsValidEmail:email];
    
    if (validEmail!=YES)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                        message:@"Please Enter a Valid Email Address. The email address is invalid"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        NSLog(@"Logging in the account");
        [self dismissKeyboard];
        
        [self.loginButton setHighlighted:YES ];
        
        NSString *url= [NSString stringWithFormat:@"http://www.funkycool.co.uk/faultguide/get_expiry_date.php?email=%@&pass=%@",email,pass];
       // NSString *url= [NSString stringWithFormat:@"http://www.funkycool.co.uk/faultguide/get_expiry_date.php?email=sudeep.talati@gmail.com&pass=123445"];
        
        NSLog(@"THE URL is  %@",url);
        NSURL *requestURL = [NSURL URLWithString:url];
        NSData *JSONData = [[NSData alloc] initWithContentsOfURL:requestURL];
        NSLog(@"No of records %d",[JSONData length]);
        NSString *response = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        NSLog(@"The response is %@",response);
        [self displayResposne:JSONData];

        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:JSONData //1
                              options:kNilOptions
                              error:&error];
        
        NSString *expiry_date=[json objectForKey:@"expiry_date"];
        NSLog(@"THE SERVER STATUS:%@",expiry_date);
        
        NSString *rawStatus=[json objectForKey:@"status"];
        NSString *server_msg=[json objectForKey:@"message"];
        
        NSLog(@"THE SERVER STATUS:%@",rawStatus);
        NSLog(@"THE SERVER Message:%@",server_msg);
        
        int status= [rawStatus intValue];
        NSLog(@"INT STATUS in Cross Check Recipet %d",status);
        //[rawStatus release];rawStatus=nil;
        
        
        
        if (status == 200){
            if([[DbHelper database]setFullVersionExpiryDate:expiry_date])
            {
                NSLog(@"New Expiry Date Set Successfully");
            }
            
            if([[DbHelper database]setRegistrationDetails:email password:pass])
            {
                NSLog(@"Registration details are set in Databse");
            }
            
        }
        
      
        
        
        
        
    }
    
    
    
    
     
    
}







@end
