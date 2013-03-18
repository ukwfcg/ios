//
//  SelectBrandForDP.h
//  faultguide
//
//  Created by Sudeep Talati on 23/01/2013.
//  Copyright (c) 2013 UK Whitegoods. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectBrandForDP : UITableViewController


@property (nonatomic, assign) int isFullDatabase;
@property (nonatomic, retain) NSArray *testList;
@property (nonatomic, assign) NSString *series_id_for_dp;


@end
