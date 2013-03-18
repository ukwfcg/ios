//
//  IAPHelper.h
//  faultguide
//
//  Created by Sudeep Talati on 19/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import <Foundation/Foundation.h>

// Add to the top of the file
#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;



typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

// Add two new method declarations
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;


-(void)checkReceipt:(NSData *)receipt;

@end
