//
//  NSString+Base64.h
//  FaultCodeGuide
//
//  Created by Sudeep Talati on 29/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

@end

