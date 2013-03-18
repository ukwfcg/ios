//
//  IAPHelper.m
//  faultguide
//
//  Created by Sudeep Talati on 19/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

// 1
#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "DbHelper.h"


#import "ReceiptCheck.h"
#import "CrossCheckReceipt.h"

// 2
@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end
NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";


@implementation IAPHelper {
    // 3
    SKProductsRequest * _productsRequest;
    // 4
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
     [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}



- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}


-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction *transaction in transactions) {
        NSLog(@"Updated transaction %@",transaction);
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed:
                [self errorWithTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing...");
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"****THIS IS CALLED WHEN ITEM IS ALREADY PURCHASED***********");
                //[self checkReceipt:transaction.transactionReceipt];
                //break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restoring.........");
                [self finishedTransaction:transaction];
                break;
            default:
                break;
        }
    }
}


-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"Restored all completed transactions");
    
     
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        NSLog(@" Prodduct restored : %@",productID);
        
        //[self checkReceipt:transaction.transactionReceipt];
        
    }
    
    
}






-(void)finishedTransaction:(SKPaymentTransaction *)transaction {
    
    
    NSLog(@"Finished transaction");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Subscription done"
     message:[NSString stringWithFormat:@"Receipt to be sent: %@\nTransaction ID: %@",transaction.transactionReceipt,transaction.transactionIdentifier]
     delegate:nil
     cancelButtonTitle:@"Close"
     otherButtonTitles:nil];
     [alert show];
     */
       NSLog(@"Transaction p i = %@", transaction.payment.productIdentifier);
    
    // save receipt
    [[NSUserDefaults standardUserDefaults] setObject:transaction.transactionIdentifier forKey:@"receipt"];
    // check receipt
    [self checkReceipt:transaction.transactionReceipt];
 
}

-(void)errorWithTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Subscription failure"
                                                    message:[transaction.error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil];
    [alert show];
    
}





- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    //NSData *r=transaction.transactionReceipt;
       //NSString *strData = [[NSString alloc]initWithData:r encoding:NSUTF8StringEncoding];
    
    [self checkReceipt:transaction.transactionReceipt];
    
    
    //NSLog(@"RECIPPT IN VARIABLE...%@",strData);
    //[self checkReceipts];
}


 








 

// Add new method
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    NSLog(@"Product Identifier is %@",productIdentifier);
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}




- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"*************** I M IN REstore omplete transaction failed with error");
    NSLog(@"Error is %@",[error description]);
}




-(void)checkReceipt:(NSData *)receipt {
    // save receipt
   NSString *receiptStorageFile = [DocumentsDirectory stringByAppendingPathComponent:@"receipts.plist"];
    NSMutableArray *receiptStorage = [[NSMutableArray alloc] initWithContentsOfFile:receiptStorageFile];
    if(!receiptStorage) {
        receiptStorage = [[NSMutableArray alloc] init];
    }
    [receiptStorage addObject:receipt];
    [receiptStorage writeToFile:receiptStorageFile atomically:YES];
    
    [CrossCheckReceipt validateReceiptWithData:receipt completionHandler:^(BOOL success,NSString *answer){
    //[ReceiptCheck validateReceiptWithData:receipt completionHandler:^(BOOL success,NSString *answer){
        if(success==YES) {
            NSLog(@"Receipt has been validated in INAPP HELPER: %@",answer);

            NSString *expiryDateString = [answer stringByReplacingOccurrencesOfString:@" Etc/GMT" withString:@""];
           
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            NSLocale *POSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ;
            [formatter setLocale:POSIXLocale];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *expiry_date_date = [formatter dateFromString:expiryDateString];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            expiryDateString= [formatter stringFromDate:expiry_date_date];
       
            NSLog(@"Expiry date is :%@",expiryDateString);
            
            if (expiryDateString!=NULL)
            {
                int fullVersionStatus=[DbHelper database].getFullVersionStatus;
                if (fullVersionStatus!=1){
                    NSLog(@"IAPHelper : Lite Version Active so UPDATING NOW");
                    
                    
                    if([[DbHelper database]setFullVersionExpiryDate:expiryDateString])
                    {
                        NSLog(@"New Expiry Date Set Successfully");
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase OK" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
                        [alert show];
                        
                        NSString *regEmail=[DbHelper database].getRegisteredEmailFromDb;
                        if ([regEmail isEqualToString:@"notset"])
                        {
                            NSLog(@"Email is Not  set");
                            
                        }
                        else
                        {
                            NSString *regPass=[DbHelper database].getRegisteredPasswordFromDb;
                            NSLog(@"Email is set");
                            
                            NSString *url= [NSString stringWithFormat:@"http://www.funkycool.co.uk/faultguide/update_expiry_date.php?email=%@&pass=%@&expiry_date=%@&no_of_times_downloadedt=1",regEmail,regPass,expiryDateString];
                            
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
                            
                            
                            
                            
                        }
                            
                                           
                        
                    }///en of if if([[DbHelper database]setFullVersionExpiryDate:expiryDateString])
                    
                    
                    
                    
                    

                }///end of if if (fullVersionStatus!=1){
            
            
            }else
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[NSString stringWithFormat:@"InappHelper : Latest reciept shows that your subscription is expired, please subscibe again"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
           
            
        } else {
            NSLog(@"Receipt not validated! In APP HELPER Error: %@",answer);
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Error" message:@"Cannot validate receipt" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            //[alert show];
        };
    }];
    
    
    
 
    
    
}











@end