//
//  CrossCheckReceipt.h
//  FaultCodeGuide
//
//  Created by Sudeep Talati on 03/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrossCheckReceipt: NSObject<NSURLConnectionDelegate> {
    NSMutableData *receivedData;
}

+(CrossCheckReceipt *)validateReceiptWithData:(NSData *)receiptData completionHandler:(void(^)(BOOL,NSString *))handler;

@property (nonatomic,copy) void(^completionBlock)(BOOL,NSString *);
@property (nonatomic,retain) NSData *receiptData;

-(void)checkReceipt;

- (NSString*) calculateExpiryDateFrom: (NSString*)purchase_date andProductId:(NSString*)product_id;




@end
