//
//  WelcomePage.m
//  faultguide
//
//  Created by Sudeep Talati on 20/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import "WelcomePage.h"
#import "FaultDatabase.h"
#import "DbHelper.h"


@interface WelcomePage ()

@end

@implementation WelcomePage

@synthesize FullVersionButton=_FullVersionButton;

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

    
    if ([DbHelper database].copyDatabase)
    {
        NSLog(@"DATA COPIED");
    }
    
    


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear : (BOOL)animated
{
    
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    /**Experiment to calculate the expiry date*/
//    
//    NSString *product_id=@"com.ukwhitegoods.faultguide.nonrenew1year";
//    NSString *purchase_date=@"2013-01-22 13:58:55";
//    
//    NSString *expiry_date=[self calculateExpiryDateFrom:purchase_date andProductId:product_id];
//    
//    NSLog(@"Calculated expiry date is %@",expiry_date);
//    
//    
    
    
    /*
    NSString *expiryDateString=@"2013-12-26 11:43:02";
    
    if([[DbHelper database]setFullVersionExpiryDate:expiryDateString])
    {
        NSLog(@"New Expiry Date Set Successfully");
    }
    */
    
    int fullVersionStatus=[DbHelper database].getFullVersionStatus;
    
    if (fullVersionStatus==0)
    {
        NSLog(@"Lite Version Active");
         [self.FullVersionButton setHidden:NO];
        
    }
    else{
        [self.FullVersionButton setHidden:YES];
        NSLog(@"Full Version ACTIVE Expiry Date %@",[DbHelper database].getFullVersionExpiryDate);
    }
}

/*
-(NSString*)calculateExpiryDateFrom:(NSString*)purchase_date andProductId:(NSString*)product_id
{
    NSString *expiry_date_string;
    
    NSLog(@" ===========================  ");
    NSLog(@" Purchase date is %@",purchase_date);
    NSLog(@" Product Id is %@",product_id);
    int daysToAdd = 0;  // or 60 :-)

    
    if ([product_id isEqualToString:@"com.ukwhitegoods.faultguide.nonrenew1month"])
    {
        daysToAdd=30;
    }
    
    if ([product_id isEqualToString:@"com.ukwhitegoods.faultguide.nonrenew1year"])
    {
        daysToAdd=365;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSLocale *POSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ;
    [formatter setLocale:POSIXLocale];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *purchase_date_date = [formatter dateFromString:purchase_date];
    
    //NSDate *now = purchase_date_date;
       
    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init] ;
    [components setDay:daysToAdd];
    
    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDate *new_expiry_date = [gregorian dateByAddingComponents:components toDate:purchase_date_date options:0];
    expiry_date_string= [formatter stringFromDate:new_expiry_date];

    //NSLog(@"Clean: %@", new_expiry_date);
     NSLog(@" ===========================  ");

    return expiry_date_string;
 }
 */

@end
