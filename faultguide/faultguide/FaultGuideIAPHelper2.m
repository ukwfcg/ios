//
//  FaultGuideIAPHelper2.m
//  faultguide
//
//  Created by Sudeep Talati on 27/02/2013.
//  Copyright (c) 2013 UK Whitegoods. All rights reserved.
//

#import "FaultGuideIAPHelper2.h"

@implementation FaultGuideIAPHelper2


+ (FaultGuideIAPHelper2 *)sharedInstance {
    static dispatch_once_t once;
    static FaultGuideIAPHelper2 * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.ukwhitegoods.faultguide.nonrenew01month",
                                     //// @"com.razeware.inapprage.updogsadness",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


@end
