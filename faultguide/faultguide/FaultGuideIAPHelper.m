//
//  FaultGuideIAPHelper.m
//  faultguide
//
//  Created by Sudeep Talati on 19/12/2012.
//  Copyright (c) 2012 UK Whitegoods. All rights reserved.
//

#import "FaultGuideIAPHelper.h"

@implementation FaultGuideIAPHelper


+ (FaultGuideIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static FaultGuideIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.ukwhitegoods.faultguide.nonrenew01month",
                                    //  @"com.ukwhitegoods.faultguide.consumable1year",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


@end
