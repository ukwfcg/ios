//
//  CrossCheckReceipt.m
//  FaultCodeGuide
//
//  Created by Sudeep Talati on 03/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrossCheckReceipt.h"
#import "NSString+Base64.h"
#import "DbHelper.h"
 

@implementation CrossCheckReceipt
#define SHARED_SECRET @"3aeef5b8fc3841d8b0bd766b77f62d80"





@synthesize receiptData,completionBlock;

+(CrossCheckReceipt *)validateReceiptWithData:(NSData *)_receiptData completionHandler:(void(^)(BOOL,NSString *))handler {
    CrossCheckReceipt *checker = [[CrossCheckReceipt alloc] init];
    checker.receiptData=_receiptData;
    checker.completionBlock=handler;
    [checker checkReceipt];
    return checker;
    
}

-(void)checkReceipt {
    // verifies receipt with Apple
    NSError *jsonError = nil;
    NSString *receiptBase64 = [NSString base64StringFromData:receiptData length:[receiptData length]];
    
    
    //NSLog(@"Receipt Base64: %@",receiptBase64);
 
    
    
    //NSString *jsonRequest=[NSString stringWithFormat:@"{\"receipt-data\":\"%@\"}",receiptBase64];
    //NSLog(@"Sending this JSON: %@",jsonRequest);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                receiptBase64,@"receipt-data",
                                                                SHARED_SECRET,@"password",
                                                                nil]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonError
                        ];
    //NSLog(@"JSON: %@",[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] ]);
    
    
    
    
    // URL for sandbox receipt validation; replace "sandbox" with "buy" in production or you will receive
    // error codes 21006 or 21007
    NSURL *requestURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if(conn) {
        receivedData = [[NSMutableData alloc] init];
    } else {
        completionBlock(NO,@"Cannot create connection");
  
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Cannot transmit receipt data. %@",[error localizedDescription]);
    completionBlock(NO,[error localizedDescription]);
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
   NSLog(@"CROSS CHECK iTunes response: %@",response);
 
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:receivedData //1
                          options:kNilOptions 
                          error:&error];
    
    
    
    NSString *rawStatus=[json objectForKey:@"status"];
    NSLog(@"Receipt Status in Cross Check Recipet:%@",rawStatus);
    
    /*This one for subscriptions*/
    //NSDictionary *r = [json objectForKey:@"latest_receipt_info"];
//    NSString *expiryDate=[r objectForKey:@"expires_date_formatted"];

    NSDictionary *r = [json objectForKey:@"receipt"];
    NSString *purchase_date_string=[r objectForKey:@"purchase_date"];
    
    purchase_date_string = [purchase_date_string stringByReplacingOccurrencesOfString:@" Etc/GMT" withString:@""];
    NSString *product_id=[r objectForKey:@"product_id"];
    
    NSString *expiryDate=@"";
    
    
    int status= [rawStatus intValue];
    NSLog(@"INT STATUS in Cross Check Recipet %d",status);
    //[rawStatus release];rawStatus=nil;
    
    if (status == 0){
        NSLog(@"Hurray");
      //  NSLog(@"Expiry Date: %@",expiryDate);
        
        //NSString *expiryDateString = [expiryDate stringByReplacingOccurrencesOfString:@" Etc/GMT" withString:@""];
       /*
        if([[DbHelper database]setFullVersionExpiryDate:expiryDateString])
        {
            NSLog(@"New Expiry Date Set Successfully");
        }
        */
        expiryDate  =[self calculateExpiryDateFrom:purchase_date_string andProductId:product_id];
        
        NSLog(@"Target Achieved");
        completionBlock(YES,expiryDate);
    }
    else {
        completionBlock(NO,expiryDate);
    }
    
    
   
}




- (NSString*) calculateExpiryDateFrom: (NSString*)purchase_date andProductId:(NSString*)product_id
{
    
    NSString *expiry_date_string;
    
    NSLog(@" ===========================  ");
    NSLog(@" Purchase date is %@",purchase_date);
    NSLog(@" Product Id is %@",product_id);
    int daysToAdd = 0;  // or 60 :-)
    
    
    if ([product_id isEqualToString:@"com.ukwhitegoods.faultguide.nonrenew01month"])
    {
        daysToAdd=30;
    }
    
    if ([product_id isEqualToString:@"com.ukwhitegoods.faultguide.nonrenew01year"])
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


@end


