//
//  ReceiptCheck.h
//  FaultCodeGuide
//
//  Created by Sudeep Talati on 29/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptCheck : NSObject<NSURLConnectionDelegate> {
    NSMutableData *receivedData;
}

+(ReceiptCheck *)validateReceiptWithData:(NSData *)receiptData completionHandler:(void(^)(BOOL,NSString *))handler;

@property (nonatomic,copy) void(^completionBlock)(BOOL,NSString *);
@property (nonatomic,retain) NSData *receiptData;

-(void)checkReceipt;

@end
