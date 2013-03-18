//
//  InAppViewController.m
//  faultguide
//
//  Created by Sudeep Talati on 27/02/2013.
//  Copyright (c) 2013 UK Whitegoods. All rights reserved.
//

#import "InAppViewController.h"
#import "FaultGuideIAPHelper2.h"
#import "DbHelper.h"

@interface InAppViewController (){
    NSArray *_products;
}

@end

@implementation InAppViewController

@synthesize label1=_label1;
@synthesize button30Days=_button30Days;
@synthesize expiryDateLabel=_expiryDateLabel;


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
 
    
}

-(void) viewWillAppear : (BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Register / Restore" style:UIBarButtonItemStyleBordered target:self action:@selector(restoreTapped:)];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home " style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonTapped:)];
    
    
    
    
    [self.button30Days setHidden:YES];
//    [self.expiryDateLabel setHidden:NO];
    
    
    // Add new instance variable to class extension
    NSNumberFormatter * _priceFormatter;
    // Add to end of viewDidLoad
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    
    [[FaultGuideIAPHelper2 sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            
            if ([_products count] !=0)
            {
                NSLog(@"My Products Found");
                SKProduct *product = [_products objectAtIndex:0];///since currently we have only one object
                [self.label1 setText:product.localizedTitle];
                
                
                //price of the app
                [_priceFormatter setLocale:product.priceLocale];
                NSString *price = [_priceFormatter stringFromNumber:product.price];
                NSString *btntext = [NSString stringWithFormat:@"Buy 30 Days Access for %@", price];
                
                [self.button30Days setTitle:btntext forState:UIControlStateNormal];
                
                    
                int fullVersionStatus=[DbHelper database].getFullVersionStatus;
                
                if (fullVersionStatus==0)
                {
                    NSLog(@"Lite Version Active");
                    [self.button30Days setHidden:NO];

                    
                }
                else{
                    
                    NSString *info= [NSString stringWithFormat: @"Your Full Version access will  expire on %@",[DbHelper database].getFullVersionExpiryDate];
                  
                    //CGRect infoLabelFrame = CGRectMake(headingMargin, drawingPosition-5, headingSize.width, headingSize.height);
                    CGRect infoLabelFrame =self.button30Days.frame;
                    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelFrame];

                    [infoLabel setText:info];
                    [infoLabel setTextAlignment:NSTextAlignmentCenter];
                    
                    [infoLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0]];
                    [infoLabel setNumberOfLines:0];
                    [self.view addSubview:infoLabel];
                    
                }
                
                            
            }
            
        }
    }];
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];

}


- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)purchase:(id)sender {
 
    NSLog(@"Purchase Clicked");
    
    
    SKProduct *product = _products[0];
    NSLog(@"Buying %@...", product.productIdentifier);
    [[FaultGuideIAPHelper2 sharedInstance] buyProduct:product];
    
}


- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            
            NSLog(@"******Purchase Successully Done for product %@",productIdentifier);
            
            NSString *expiry_date=[self calculateExpiryDateFromNowForProductId:productIdentifier];
    
            NSLog(@"Expiry date of product is %@",expiry_date);
 
            
            NSString *msg=@"";
            if (expiry_date!=NULL)
            {
                if([[DbHelper database]setFullVersionExpiryDate:expiry_date])
                {
                    NSLog(@"New Expiry Date Set Successfully");
                    msg=[NSString stringWithFormat:@"Access Granted for full Version until %@",expiry_date] ;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase OK" message:msg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                    [alert show];
                    
                    [self.expiryDateLabel setText:msg];
                    [self.expiryDateLabel setHidden:NO];
                    [self.button30Days setHidden:YES];
                    
                    NSString *regEmail=[DbHelper database].getRegisteredEmailFromDb;
                    if ([regEmail isEqualToString:@"notset"])
                    {
                        NSLog(@"Email is Not  set");
                        msg=[NSString stringWithFormat:@"You are not registered with us. Please register so that you can restore your purchases in future. In case this app is deleted accidently or you have replaced your phone, you will not be able to claim your subscription if you are not registered. "] ;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Details Missing !!" message:msg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                        [alert show];
                    }///end of   if ([regEmail isEqualToString:@"notset"])
                    else
                    {
                        NSString *regPass=[DbHelper database].getRegisteredPasswordFromDb;
                        NSLog(@"Email is set");
                        
                        NSString *url= [NSString stringWithFormat:@"http://www.funkycool.co.uk/faultguide/update_expiry_date.php?email=%@&pass=%@&expiry_date=%@&no_of_times_downloaded=1",regEmail,regPass,expiry_date];
                        
                        NSLog(@"THE URL is  %@",url);
                        NSURL *requestURL = [NSURL URLWithString:url];
                        NSData *JSONData = [[NSData alloc] initWithContentsOfURL:requestURL];
                        NSLog(@"No of records %d",[JSONData length]);
                        NSString *response = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
                        NSLog(@"The response is %@",response);
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
                        
                        
                        if (status == 200){
                            NSLog(@"Expiry date updated on ");
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Updated"
                                                                            message:server_msg
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Close"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }
                        if (status == 204){
                            NSLog(@"Error in Updating on serevr");
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Updated"
                                                                            message:server_msg
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Close"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }
                        
                        
                    }///ennd of else([regEmail isEqualToString:@"notset"])
                    
                    
                    
                }///end of if expiry_date if([[DbHelper database]setFullVersionExpiryDate:expiry_date])
                else
                {
                    NSLog(@"Error in setting New Expiry Date");
                    msg=[NSString stringWithFormat:@"Unable to set the date %@, Please contact the developer",expiry_date] ;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                    [alert show];
                    
                    
                }//end of else expiry_date if([[DbHelper database]setFullVersionExpiryDate:expiry_date])
                
                
            }////end of if expiry date is not null
            else
            {
                msg=@"Expiry date is Nil, Could not get system date.";
                NSLog(@"%@",msg);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                [alert show];
                
            }

        
        
        
        
        
        }
    }];////end of BLOCK    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
    
    
}



#pragma mark myOwnMethods

- (NSString*) calculateExpiryDateFromNowForProductId:(NSString*)product_id{

    NSString *expiry_date_string;
    int daysToAdd=0;
    if ([product_id isEqualToString:@"com.ukwhitegoods.faultguide.nonrenew01month"])
    {
        daysToAdd=30;
    }
    
    
    /*Todays date*/
    NSDate *today = [NSDate date];
    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    [components setDay:daysToAdd];
    
    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDate *new_expiry_date = [gregorian dateByAddingComponents:components toDate:today options:0];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSLocale *POSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ;
    [formatter setLocale:POSIXLocale];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    expiry_date_string= [formatter stringFromDate:new_expiry_date];
//    NSLog(@"Clean: %@", expiry_date_string);
//    NSLog(@" ===========================  ");
    return expiry_date_string;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"createAccount"]) {
    }
}

- (void)restoreTapped:(id)sender {
    
    [self performSegueWithIdentifier:@"createAccount" sender:self];
}



- (void)backButtonTapped:(id)sender {
    
    [self performSegueWithIdentifier:@"backButton" sender:self];
}



- (IBAction)register_login_btn:(id)sender {
    
    [self performSegueWithIdentifier:@"createAccount" sender:self];

    
}
@end
